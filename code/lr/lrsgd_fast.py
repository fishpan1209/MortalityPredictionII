#!/usr/bin/env python
"""
Implement your own version of logistic regression with stochastic
gradient descent.

Author: tpan35
Email : tpan35@gatech.edu
"""

import collections
import math


class LogisticRegressionSGD:

    def __init__(self, eta, mu, n_feature):
        """
        Initialization of model parameters
        """
        self.eta = eta
        self.mu = mu

        self.weight = [0.0] * n_feature

    def fit(self, X, y):
        """
        Update model using a pair of training sample
        """


        
        #y_t=1.0 / (1.0 + math.exp(-math.fsum((self.weight[i]*X[i][1] for i in range(0,n_feature)))))
       
        y_t=self.predict_prob(X)
        for f,v in X:
            self.weight[f] = self.weight[f]*(1-2*self.mu*self.eta)+self.eta*(y-y_t)*v
 
        return self.weight

    def predict(self, X):
        return 1 if predict_prob(X) > 0.5 else 0

    def predict_prob(self, X):
        return 1.0 / (1.0 + math.exp(-math.fsum((self.weight[f]*v for f, v in X))))
