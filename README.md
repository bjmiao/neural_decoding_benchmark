# Neural Decoding Benchmark

A scalable and flexible framework for benchmarking different neural decoding methods.

## Architecture
This benchmarking framework is designed to be modular and scalable. It consists of three main components:
1. Adapter: Loads the data from the source.
    Basically, it takes the data from the source and convert it into a data matrix X, label matrix y and metadata for the next step.
2. Formatter: Formats the data into a suitable format for decoding.
    It takes the data matrix X, label matrix y and metadata and convert it (X_train, X_test, y_train, y_test) format for the decoder.
3. Decoder: Decodes the data using a specified method.
    It runs the decoding process and reports the results


## Installation

```bash
pip install .
(pip install -e . for editable mode)
```

## Usage

In general, the command is:

```bash
python neural_decoding/run.py \
--adapter AdapterName [--adapter_args arg_name1=arg_value1,arg_name2=arg_value2] \
--formatter FormatterName [--formatter_args] \
--decoder DecoderName [--decoder_args] \
--logpath logs/ --logfile neural_decoding
```

Take Coen Orientation Tuning dataset as an example.

```bash
python neural_decoding/run.py \
--adapter CoenOriAdapter --adapter_args --adapter_args filepath:/path/to/data/10.mat \
--formatter SimpleSplitFormatter \
--decoder LinearRegressionDecoder \
--logpath logs/ --logfile neural_decoding
```

Notice, since we cannot accept colon in the argument, we need to make sure the current working directory (the drive name) is the same as the drive of filepath.

## License
See LICENSE file.