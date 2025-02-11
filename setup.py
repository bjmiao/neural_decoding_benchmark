from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setup(
    name="neural_decoding",
    version="0.1",
    description="A package for neural decoding tasks",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/yourusername/neural-decoding",
    packages=find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.6",
    install_requires=[
        "numpy",
        "pandas",
        "scikit-learn",
        "matplotlib",
    ],
    entry_points={
        'console_scripts': [
            'neural-decode=neural_decoding.cli.decode:main',
        ],
    },
)