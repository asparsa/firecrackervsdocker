# Firecracker vs Docker
# rep description
In this report, a machine learning model (KNN) is run on Firecracker and a Docker container, both on CPU, and the performance of the algorithm is benchmarked in both scenarios. GPU utilization is not taken into account.

# Firecracker part
there is a complete documentat on [Getting Started with Firecracker](https://github.com/firecracker-microvm/firecracker/blob/main/docs/getting-started.md#getting-started-with-firecracker). but if you are already familiar with Firecracker you can follow this procedure:
-  

# why KNN
It is preferable to run a more complex DNN in order to gain insight into the impact of the underlying system on the model-serving performance. However, due to time constraints, it was decided to opt for the KNN approach initially. In order to provide more accurate results, the model should be run 100 or 1000 times and the average time calculated so having a more complex model will multiply the time. This is due to the fact that a single run may be biased and not provide an accurate result. Additionally, the complexity of a model requires the downloading of numerous libraries when building a Docker Image. This can be a challenge due to current connection and filtering issues within Iran. As such, the KNN model was written from scratch, only relying on the NumPy library.
