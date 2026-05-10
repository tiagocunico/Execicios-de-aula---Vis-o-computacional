import cv2
import numpy as np

img = cv2.imread('Lista 5/imgs_lista_5/I1_r1.bmp', cv2.IMREAD_GRAYSCALE)
h, w = img.shape
min_var = float('inf')
best_x, best_y = 0, 0
size = 50

for y in range(0, h - size, 10):
    for x in range(0, w - size, 10):
        block = img[y:y+size, x:x+size]
        var = np.var(block)
        if var < min_var:
            min_var = var
            best_x, best_y = x, y

print(f"Best I1_r1 block: x={best_x}, y={best_y}, var={min_var}")

img2 = cv2.imread('Lista 5/imgs_lista_5/I2_r1.bmp', cv2.IMREAD_GRAYSCALE)
h, w = img2.shape
min_var = float('inf')
best_x2, best_y2 = 0, 0

for y in range(0, h - size, 10):
    for x in range(0, w - size, 10):
        block = img2[y:y+size, x:x+size]
        var = np.var(block)
        if var < min_var:
            min_var = var
            best_x2, best_y2 = x, y

print(f"Best I2_r1 block: x={best_x2}, y={best_y2}, var={min_var}")
