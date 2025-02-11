'''
This is the entry point of running a single decoding test.

Basically it takes the command line arguments and do the following:
1. Load data (through an implementation of 'adapter' class)
2. Generate dataset (through an implementation of 'formatter' class)
3. Decode (through an implementation of 'decoder' class)

The result is saved in the log file.
'''

# Standard library imports
import argparse
import importlib
import json
import logging
import os
import sys
import time
from pathlib import Path
from typing import Dict, Any

# Third-party imports
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split

# Local application imports
from neural_decoding.utils.zscore import zscore_transform

def parse_dict_arg(arg: str) -> Dict[str, Any]:
    """Parse a string of format 'key1:value1,key2:value2' into a dictionary."""
    if not arg:
        return {}
    
    try:
        # Split by commas, then by colons
        pairs = [pair.split(':') for pair in arg.split(',')]
        # Convert string values to appropriate types (int, float, bool, or keep as string)
        parsed_dict = {}
        for key, value in pairs:
            # Try to convert to int/float/bool
            try:
                if value.lower() == 'true':
                    parsed_value = True
                elif value.lower() == 'false':
                    parsed_value = False
                elif '.' in value:
                    parsed_value = float(value)
                else:
                    parsed_value = int(value)
            except ValueError:
                parsed_value = value  # Keep as string if conversion fails
            parsed_dict[key.strip()] = parsed_value
        return parsed_dict
    except Exception as e:
        raise ValueError(f"Invalid dictionary format. Expected 'key1:value1,key2:value2'. Got: {arg}") from e

def parse_args():
    parser = argparse.ArgumentParser(description='Neural decoding pipeline')
    
    # Adapter arguments
    parser.add_argument('adapter', type=str,
                      help='Name of the adapter class to use')
    parser.add_argument('--adapter_args', type=str, default='',
                      help='Arguments for adapter as key:value pairs')
    
    # Formatter arguments
    parser.add_argument('formatter', type=str,
                      help='Name of the formatter class to use (e.g., GeneralizationTrialFormatter)')
    parser.add_argument('--formatter_args', type=str, default='',
                      help='Arguments for formatter as key:value pairs')
    
    # Decoder arguments
    parser.add_argument('decoder', type=str,
                      help='Name of the decoder class to use (e.g., LinearDecoder)')
    parser.add_argument('--decoder_args', type=str, default='',
                      help='Arguments for decoder as key:value pairs')
    
    # Logging arguments
    parser.add_argument('--logpath', type=str, default='logs',
                      help='Path to store log files')
    parser.add_argument('--logfile', type=str, default='neural_decoding',
                      help='Base name for log file')
    
    args = parser.parse_args()
    
    # Parse dictionary arguments
    args.adapter_args = parse_dict_arg(args.adapter_args)
    args.formatter_args = parse_dict_arg(args.formatter_args)
    args.decoder_args = parse_dict_arg(args.decoder_args)
    
    return args

def get_class(module_name: str, class_name: str):
    """Dynamically import a class from a module."""
    try:
        module = importlib.import_module(f'neural_decoding.{module_name}')
        return getattr(module, class_name)
    except (ImportError, AttributeError) as e:
        raise ImportError(f"Could not import {class_name} from neural_decoding.{module_name}: {e}")

def main():
    # Parse arguments
    args = parse_args()
    
    # Setup logging
    os.makedirs(args.logpath, exist_ok=True)
    today = time.strftime("%Y%m%d", time.localtime())
    logging.basicConfig(
        filename=os.path.join(args.logpath, f"{args.logfile}_{today}.log"),
        filemode='a',
        format='%(asctime)s,%(msecs)d %(name)s %(levelname)s %(message)s',
        datefmt='%H:%M:%S',
        level=logging.INFO
    )
    
    logger = logging.getLogger(__name__)
    logger.info(f"Starting decoding with arguments: {args}")
    
    try:
        # Dynamically load and instantiate classes
        AdapterClass = get_class('adapters', args.adapter)
        FormatterClass = get_class('formatters', args.formatter)
        DecoderClass = get_class('decoders', args.decoder)
        
        # Create instances
        adapter = AdapterClass(**args.adapter_args)
        formatter = FormatterClass(**args.formatter_args)
        decoder = DecoderClass(**args.decoder_args)
        
        # Run the pipeline
        logger.info("Loading data through adapter...")
        X, y, metadata = adapter.load_data()
        
        logger.info("Formatting data...")
        X_train, X_test, y_train, y_test = formatter.format_data(X, y, metadata)
        
        logger.info("Training decoder...")
        decoder.fit(X_train, y_train)
        
        logger.info("Evaluating decoder...")
        scores = decoder.score(X_test, y_test)
        
        # Log results
        logger.info(f"Decoding results: {scores}")
        
    except Exception as e:
        logger.error(f"Error during decoding: {str(e)}", exc_info=True)
        raise

if __name__ == "__main__":
    main()