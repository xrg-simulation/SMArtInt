# -*- coding: utf-8 -*-
import os
import numpy as np
import matplotlib.pylab as plt
import tensorflow as tf
from enum import Enum

class RnnType(Enum):
    """Available types of RNN"""
    RNN = 0
    EXTSTATE = 1
    STATE = 2


def generate_ai_pi(rnn_type: RnnType, window_size=1, k=30, T=1600, tau=100):
    stateful = rnn_type == RnnType.STATE

    if rnn_type == RnnType.EXTSTATE:
        model_input = tf.keras.Input(batch_shape=(None, 1, 1), name="FeatureInput")
    elif rnn_type == RnnType.STATE:
        model_input = tf.keras.Input(batch_shape=(1, 1, 1), name="FeatureInput")
    else:
        model_input = tf.keras.Input(batch_shape=(None, window_size, 1), name="FeatureInput")

    layer = tf.keras.layers.SimpleRNN(units=2,
                                      activation='linear',
                                      use_bias=False,
                                      stateful=stateful,
                                      return_state=True,
                                      unroll=True,
                                      name="ZPassAndIntegrate",
                                      )
    state_input = tf.keras.Input(batch_shape=(None, 2,))
    if rnn_type == RnnType.EXTSTATE:
        out, state = layer(model_input, initial_state=[state_input])
    else:
        out, state = layer(model_input, )
    out = tf.keras.layers.Dense(units=1,
                                activation='linear',
                                use_bias=False,
                                name="Weight")(out)
    if rnn_type == RnnType.EXTSTATE:
        model = tf.keras.Model([model_input, state_input], [out, state])
    else:
        model = tf.keras.Model([model_input], [out])

    # Manipulate weights to mimic PI controller
    model.layers[-1].set_weights([np.array([[k / T * tau], [k]])])
    model.layers[-2].set_weights([
        np.array([[0, 1]]),
        np.array([[1, 0],
                  [1, 0]])
    ])
    return model


def step_response(height=1.0, duration=3600, start=500, tau=100, window_size=500):
    times = np.arange(0, duration, tau)
    step_data = np.zeros_like(times)
    step_data[times >= start] = height
    unrld_data = np.zeros([len(step_data), window_size, 1])
    for i in range(len(step_data)):
        start_idx = max(0, i - window_size + 1)
        n_elements = i - start_idx + 1
        unrld_data[i, -n_elements:, 0] = step_data[start_idx: i + 1]

    return times, step_data, unrld_data


### ---------------------- Settings for the PI ----------------------
k = 30  # proportional gain
T = 1600  # integrator time constant
window_size = 250  # number of past elements used for non-state variant
rnn_type = RnnType.RNN # define type of used RNN
if rnn_type == RnnType.RNN:
    tau = 100  # sampling rate
else:
    tau = 10
test_tflite_model = True
### Test settings
test_keras_model = True

# Create model and test data
model = generate_ai_pi(rnn_type, window_size=window_size, k=k, T=T, tau=tau)
times, step_data, unrld_data = step_response(height=1, duration=3600, start=500,
                                             tau=tau, window_size=window_size)

# Test Keras model
if test_keras_model:
    results = []
    if rnn_type == RnnType.RNN:
        results = model.predict(unrld_data).flatten()
    elif rnn_type == RnnType.STATE:
        model.reset_states()
        for val in step_data:
            # Predict expects a batch, so we wrap val twice
            pred = model.predict(np.array([[[val]]]), verbose=0)
            results.append(pred.flatten()[0])
    elif rnn_type == RnnType.EXTSTATE:
        states = np.array([[0, 0]], dtype=np.float32)
        for val in step_data:
            # Predict with external state
            pred, states = model.predict([np.array([[[val]]]), states], verbose=0)
            results.append(pred.flatten()[0])

    plt.figure()
    plt.title(f'Step Response of Keras Model ({rnn_type.name})')
    plt.xlabel('Time in sec')
    plt.ylabel('Model Output')
    plt.ylim([0, 100])
    plt.plot(times, results)
    plt.grid(True)
    plt.show()

### --------- Export To TFLite ------------------------------
if rnn_type != RnnType.STATE:
    # Export the model as TFLite model
    if rnn_type == RnnType.EXTSTATE:
        @tf.function
        def serve_model(feature, state):
            return model([feature, state])

        concrete_func = serve_model.get_concrete_function(
            tf.TensorSpec([None, 1, 1], model.inputs[0].dtype, name="FeatureInput"),
            tf.TensorSpec([None, 2], model.inputs[1].dtype, name="StateInput")
        )

        converter = tf.lite.TFLiteConverter.from_concrete_functions([concrete_func], None)
    else:
        converter = tf.lite.TFLiteConverter.from_keras_model(model)

    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS,
                                           tf.lite.OpsSet.SELECT_TF_OPS]
    tflite_model = converter.convert()
    
    if rnn_type == RnnType.EXTSTATE:
        tflite_path = os.path.join('.', "PI_stateful.tflite")
    else:
        tflite_path = os.path.join('.', "PI.tflite")
        
    with open(tflite_path, 'wb') as f:
        f.write(tflite_model)

    if test_tflite_model:
        interpreter = tf.lite.Interpreter(model_path=tflite_path)
        interpreter.allocate_tensors()
        input_details = interpreter.get_input_details()
        output_details = interpreter.get_output_details()

        results = []
        if rnn_type == RnnType.EXTSTATE:
            states = np.array([[0, 0]], dtype=input_details[1]['dtype'])
            for data_point in step_data:
                np_features = np.array([[[data_point]]], dtype=input_details[0]['dtype'])
                interpreter.set_tensor(input_details[0]['index'], np_features)
                interpreter.set_tensor(input_details[1]['index'], states)
                interpreter.invoke()
                
                output = interpreter.get_tensor(output_details[0]['index'])
                results.append(output.flatten()[0])
                states = interpreter.get_tensor(output_details[1]['index'])
        else:
            for i in range(len(step_data)):
                np_features = np.array([unrld_data[i, :, :]], dtype=input_details[0]['dtype'])
                interpreter.set_tensor(input_details[0]['index'], np_features)
                interpreter.invoke()
                output = interpreter.get_tensor(output_details[0]['index'])
                results.append(output.flatten()[0])

        plt.figure()
        plt.title(f'Step Response of TFLite Model ({rnn_type.name})')
        plt.xlabel('Time in sec')
        plt.ylabel('Model Output')
        plt.ylim([0, 100])
        plt.plot(times, results)
        plt.grid(True)
        plt.show()
else:
    print("Stateful model (RnnType.STATE) cannot be easily exported as standard TFLite model!")

### --------- Export To ONNX ------------------------------
model.summary()
save_path = "savedmodel"
model.save(save_path)

if rnn_type == RnnType.EXTSTATE:
    os.system(f"python -m tf2onnx.convert --saved-model {save_path} --output PI_stateful.onnx --opset 13")
elif rnn_type == RnnType.RNN:
    os.system(f"python -m tf2onnx.convert --saved-model {save_path} --output PI.onnx --opset 13")
elif rnn_type == RnnType.STATE:
    print("ONNX conversion for RnnType.STATE might require additional configuration.")
