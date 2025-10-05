# K-means vs Gaussian Mixture Model Clustering Comparison

A visual demonstration showing how K-means and Gaussian Mixture Models (GMM) can assign points differently even when using identical cluster centers.

## 📊 Overview

This R script demonstrates a fundamental difference between K-means and GMM clustering algorithms:

- **K-means**: Uses hard assignment based solely on Euclidean distance to cluster centers
- **GMM**: Uses soft assignment based on posterior probabilities, considering distance, covariance matrices, and mixing weights

The demonstration shows that **three points assigned to different clusters in K-means can be assigned to the same cluster in GMM**, even when both algorithms use identical cluster centers.

## 🎯 Key Concept

While K-means assigns each point to its nearest center, GMM considers:
1. **Distance** to cluster centers
2. **Covariance matrices** (cluster shape and spread)
3. **Mixing weights** (prior probabilities)

This allows GMM to create more flexible cluster boundaries that can unite points that K-means would separate.

## 📋 Requirements

```r
# Required R packages
- mclust (>= 5.4)
- tidyverse (>= 2.0)
- patchwork (>= 1.1)
```

## 🚀 Installation

```r
# Install required packages
install.packages(c("mclust", "tidyverse", "patchwork"))
```

## 💻 Usage

```r
# Run the script
source("kmeans_vs_gmm_demo.R")
```

The script will:
1. Generate synthetic data with 5 clusters
2. Run both K-means and GMM clustering
3. Identify example points demonstrating the concept
4. Display console output with cluster assignments and probabilities
5. Create and save a high-resolution comparison plot

## 📈 Output

### Console Output

The script provides:
- Coordinates and cluster assignments for three example points
- GMM posterior probabilities showing why points are grouped together
- Confirmation of saved plot file

### Visualization

A side-by-side comparison plot showing:
- **Left panel**: K-means clustering (example points in different clusters)
- **Right panel**: GMM clustering (example points in same cluster)
- **Stars (★)**: Cluster centers (identical in both algorithms)
- **Triangles (▲)**: Example points demonstrating the concept
- **Circles (●)**: Other data points

The plot is saved as `kmeans_vs_gmm_comparison.png` at 300 DPI (publication quality).

## 🎨 Features

- **Colorblind-friendly palette**: Uses Okabe-Ito colors for accessibility
- **Tidyverse approach**: Modern, readable R code with pipes and dplyr
- **Professional visualization**: Publication-ready plots with custom theming
- **High-resolution export**: 300 DPI PNG output for presentations and papers
- **Reproducible**: Set seed ensures consistent results

## 🔬 Technical Details

### Data Generation
- 1 large, diffuse cluster (150 points, σ = 2.5)
- 4 small, tight clusters (20 points each, σ = 0.5)

### Algorithms
- **K-means**: Standard algorithm with 25 random starts
- **GMM**: Full covariance model (VVV) initialized with K-means results

### Example Point Selection
The script automatically identifies three points that:
1. Belong to different clusters under K-means
2. Belong to the same cluster under GMM

## 📚 Educational Use

This demonstration is ideal for:
- Machine learning courses
- Clustering algorithm tutorials
- Statistical learning presentations
- Research papers on clustering methods

## 🖼️ Example Output

The visualization clearly shows how GMM's probabilistic approach can create different cluster assignments than K-means' distance-based method, providing intuition for when to choose each algorithm.

## 👤 Author

**M. Nsofu**  
October 2025

## 📄 Citation

If you use this code in your research or teaching, please cite:

```
Nsofu, M. (2025). K-means vs Gaussian Mixture Model Clustering Comparison. 
GitHub repository: https://github.com/RProDigest/Predictive-Modeling-Week8
```

## 📖 References

Bishop, C. M. (2006). *Pattern Recognition and Machine Learning*. Springer.

## 📝 License

MIT License - feel free to use and modify for educational and research purposes.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

## ⭐ Acknowledgments

- Color palette: Okabe & Ito (2008) colorblind-friendly palette
- Inspired by theoretical discussions in pattern recognition literature
