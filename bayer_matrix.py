import sys
import numpy as np

M2 = np.array([[0, 2], [3, 1]]) / 4


def bayer(n):
    n /= 2
    n = int(n)
    if n <= 1:
        return M2
    m = np.kron(np.ones([2, 2]), bayer(n))
    m += np.kron(M2 / (n * n), np.ones([n, n]))
    return m


if __name__ == "__main__":
    mat = bayer(int(sys.argv[1]))
    out = ""
    for r in range(mat.shape[0]):
        for c in range(mat.shape[1]):
            out += str(mat[r][c]) + ", "
        out += "\n"
    print(out)
