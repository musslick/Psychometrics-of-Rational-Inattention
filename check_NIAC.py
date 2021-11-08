import numpy as np

import itertools

from itertools import chain, combinations

import networkx as nx

'''

Data P and Prize R has dimension (num of data, num of states, num of actions)

Note: although the state set must be shared across Data, the number of actions don't have to.

In case where they don't, numpy array may not be the best data structure.

'''

P = np.array([[[0.23, 0.02], [0.2, 0.05], [0.05, 0.2], [0.02, 0.23]],

              [[0.24, 0.01], [0.22, 0.03], [0.03, 0.22], [0.01, 0.24]],

              [[0.22, 0.03], [0.22, 0.03], [0.07, 0.18], [0.07, 0.18]]])

R = np.array([[['T1', 'F'], ['T1', 'F'], ['F', 'T1'], ['F', 'T1']],

              [['T2', 'F'], ['T2', 'F'], ['F', 'T2'], ['F', 'T2']],

              [['T2', 'T1'], ['T2', 'T1'], ['T1', 'T2'], ['T1', 'T2']]])

R_unique = np.unique(R)


def example_u(prize):
    table = {'T1': 0.05, 'T2': 0.1, 'F': 0}

    return table[prize]


def d(a, b, Ri, Pi):
    '''

    a and b are two action index

    Ri is the Prize table for data i

    Pi is the SDSC data for data i

    '''

    R_unique = np.unique(Ri)

    indicate = (Ri[:, a] == R_unique.reshape(-1, 1)).astype(int) - (Ri[:, b] == R_unique.reshape(-1, 1)).astype(int)

    return indicate.dot(Pi[:, a])


def NIAS(Ri, Pi, u):
    n_actions = Ri.shape[1]

    assert n_actions == Pi.shape[1]

    R_unique = np.unique(Ri)

    utilities = np.array([u(r) for r in R_unique])

    for element in itertools.product(range(n_actions), range(n_actions)):

        satisfied = (d(element[0], element[1], Ri, Pi).dot(utilities) >= 0)

        if not satisfied:
            return False

    return True


def NIAS_F(R, P, u):
    '''

    essentially NIAS for all data sets

    '''

    num_data = len(R)

    assert len(P) == num_data

    for i in range(num_data):

        satisfied = NIAS(R[i], P[i], u)

        if not satisfied:
            return False

    return True


def NIAC(R, P, u):
    num_data, num_states, num_actions = P.shape

    assert P.shape == R.shape

    utility = np.vectorize(u)(R)

    utility_nextData = np.roll(utility, -1, axis=0)  # move the utility of first data to the end, forming cycle

    EU = np.sum(utility * P)

    MU_switch = np.array([np.max(utility_nextData[d].T.dot(P[d]), axis=0) for d in range(num_data)])

    return EU >= np.sum(MU_switch)


def NIAC_F(R, P, u):
    '''

    Note: this function does involve some repetitive computing.

    i.e., checking difference cycles share some computations so if needed this function can be more optimized.

    '''

    num_data, num_states, num_actions = P.shape

    assert P.shape == R.shape

    G = nx.DiGraph()

    # Add a list of nodes:

    G.add_nodes_from(range(3))

    # Add a list of edges:

    G.add_edges_from(itertools.product(range(3), range(3)))

    cycles = list(nx.simple_cycles(G))

    for c in cycles:

        if len(c) > 1:  # note when len(c) == 1, NIAC is the same as NIAS. So here we don't consider them

            satisfied = NIAC(R[c], P[c], u)

            if not satisfied:
                return False

    return True