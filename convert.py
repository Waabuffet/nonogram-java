from scipy.ndimage import zoom
from PIL import Image
import numpy as np

zoomValue = 1/55

srcImage = Image.open("image.jpg")
grayImage = srcImage.convert('L')
array = np.array(grayImage)
array = zoom(array, zoomValue)

np.savetxt("result.txt", array<128, fmt="%d")