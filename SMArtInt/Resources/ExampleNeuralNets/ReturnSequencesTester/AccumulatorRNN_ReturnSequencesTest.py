import numpy as np
import os
os.environ["KERAS_BACKEND"] = "tensorflow"
import tensorflow as tf

# Parameters
timesteps = 10
features = 1
units = 2
batch_size = 1

save_models = True

# Input
x = np.arange(1, timesteps+1).reshape((batch_size, timesteps, features)).astype(np.float32)
print("Input:", x[0,:,0])

# ---- SimpleRNN with return_sequences=True ----
rnn_seq = tf.keras.layers.SimpleRNN(
    units=units,
    activation="linear",
    use_bias=False,
    return_sequences=True,
    unroll=True
)
model_seq = tf.keras.Sequential([rnn_seq])
model_seq.build(input_shape=(batch_size, timesteps, features))

# Set weights manually
kernel = np.array([[1.0, 2.0]])  # input -> hidden
recurrent_kernel = np.array([[1, 0.0],
                             [0.0, 1]])  # hidden -> hidden

rnn_seq.set_weights([kernel, recurrent_kernel])

# Prediction
y_seq = model_seq.predict(x)
print("\nOutput return_sequences=True:")
print(np.round(y_seq[0], 4))

# ---- SimpleRNN with return_sequences=False ----
rnn_last = tf.keras.layers.SimpleRNN(
    units=units,
    activation="linear",
    use_bias=False,
    return_sequences=False,
    unroll=True
)
model_last = tf.keras.Sequential([rnn_last])
model_last.build(input_shape=(batch_size, timesteps, features))

# Use same weights
rnn_last.set_weights([kernel, recurrent_kernel])

# Prediction
y_last = model_last.predict(x)
print("\nOutput return_sequences=False (only last timestep):")
print(np.round(y_last[0], 4))

# ---- Comparison ----
print("\nComparison last row vs return_sequences=False:")
print("Difference:", np.round(y_seq[0, -1] - y_last[0], 8))

if save_models:
    # TFLite Converter for return_sequences=True
    # Conversion via from_keras_model
    converter = tf.lite.TFLiteConverter.from_keras_model(model_seq)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS]
    tflite_model_seq = converter.convert()

    # Save
    with open("accumulatorRNN_seq.tflite", "wb") as f:
        f.write(tflite_model_seq)
    print("TFLite model (return_sequences=True) saved as accumulatorRNN_seq.tflite")

    # TFLite Converter for return_sequences=False
    converter = tf.lite.TFLiteConverter.from_keras_model(model_last)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS]

    tflite_model_last = converter.convert()

    # Save
    with open("accumulatorRNN_last.tflite", "wb") as f:
        f.write(tflite_model_last)
    print("TFLite model (return_sequences=False) saved as accumulatorRNN_last.tflite")
