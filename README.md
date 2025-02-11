# Neural Decoding Benchmark

A scalable and flexible framework for benchmarking different neural decoding methods.

## Installation

```bash
pip install .
(pip install -e .) for editable mode
```

## Usage

```bash
python neural_decoding/run.py \
--adapter ToyAdapter [--adapter_args n_samples=1000,n_dim=5] \
--formatter ToyFormatter [--formatter_args] \
--decoder LinearDecoder [--decoder_args] \
--logpath logs/ --logfile neural_decoding
```

## Development

To set up the development environment:

1. Clone the repository
2. Create a virtual environment
3. Install development dependencies:
   ```bash
   pip install -e ".[dev]"
   ```

## License
See LICENSE file.