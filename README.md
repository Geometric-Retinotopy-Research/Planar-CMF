# Planar-CMF

This repository contains code for computing cortical magnification factor (CMF) and generating analysis results based on planar retinotopic maps.

## 📁 Directory Structure

```
root/
├── codes/
├── data/           # Place downloaded data here
    ├── HCP_data/   # preprocessed HCP data
    ├── NYU_data/   # preprocessed HCP data
├── data/           # Place for results
├── README.md
```

## Step 1: Download Data

Download the required dataset from the following link:

**[Download Data](https://example.com/data-link)**

Place the unzipped `data/` folder **next to** the `codes/` folder (i.e., as a sibling directory in the repository root) as shown above.

---

## Step 2: Set Up Dependencies in MATLAB

Launch MATLAB and add all subdirectories inside the `codes/` folder to the path:

```matlab
addpath(genpath('codes'));
```

---

## Step 3: Generate Results

To run the full pipeline and generate all result files, execute the following script in MATLAB:

```matlab
run('codes/GenResults_All.m');
```

---

## Step 4: Compute CMF and Generate Output Figures

To compute the cortical magnification factor (CMF) and other key visualizations:

```matlab
run('codes/GenFigure_CMF_HCP.m');
```

This script will generate CMF maps and associated analysis results.

---

## Notes

- The scripts are tested on MATLAB 2022b or later.
- If you encounter path or file errors, double-check that the folder layout matches the structure above.

---

## 📄 License

This project is released under the MIT License.
