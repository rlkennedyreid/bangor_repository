import numpy as np
from numpy import fft
from math import pi
import matplotlib.pyplot as plt
from random import gauss

def argand(a):
    import matplotlib.pyplot as plt
    import numpy as np
    for x in range(len(a)):
        plt.plot([0,a[x].real],[0,a[x].imag],'r.',label='python')
    limit=np.max(np.ceil(np.absolute(a))) # set limits for axis
    plt.xlim((-limit,limit))
    plt.ylim((-limit,limit))
    plt.ylabel('Imaginary')
    plt.xlabel('Real')
    plt.show()




num_samples = 100

start_point = 0.0
end_point = 5.0

sample_period = (end_point - start_point)/num_samples



#x_range = np.linspace(start_point, end_point, num_samples)

sample_rate = 200
x_range = np.arange(start_point, end_point, 1/sample_rate)
series = [gauss(0.0, 1.0) for i in range(1000)]
sine_frequency = 5.0
#sine_wave = np.sin((pi/4.0) + 2.0*pi*sine_frequency*x_range)
sine_wave = series
freq_vals = fft.fftfreq(len(x_range), x_range[1]-x_range[0])
fft_output = fft.fft(sine_wave)


max_location = np.where(abs(fft_output) == np.max(abs(fft_output)))[0]
print(freq_vals[max_location])
print(abs(fft_output[max_location]))
plt.plot(x_range, sine_wave)
plt.show()


plt.scatter(freq_vals, abs(fft_output))
plt.xlim(-10,10)
plt.show()

argand(fft_output)
#plt.scatter(fft_output[max_location].real, fft_output[max_location].imag)
