# START UP
import os
import pigpio, time, csv
from datetime import datetime


# IMPORTS
os.system('sudo pigpiod') # run pigpio daemon
os.chdir('/home/pi/Project/BIOE4900github') # cd to where DHT22 python file is
os.system('git init')
import DHT22

# VARIABLES
pi = pigpio.pi()
hist_sensor_values_file_path = "/home/pi/Project/BIOE4900github/BIOE4900-sensor-values-" + datetime.now().strftime("%Y-%m-%d-%H-%M-%S")  + ".csv" 

s1  = DHT22.sensor(pi,4) # sensor 1 on GPIO 4
s2  = DHT22.sensor(pi,17)
s3  = DHT22.sensor(pi,27)
s4  = DHT22.sensor(pi,22)
s5  = DHT22.sensor(pi,23)
s6  = DHT22.sensor(pi,24)
s7  = DHT22.sensor(pi,25)
s8  = DHT22.sensor(pi,5)
s9  = DHT22.sensor(pi,6)
s10 = DHT22.sensor(pi,13)
s11 = DHT22.sensor(pi,26)
s12 = DHT22.sensor(pi,12)
s13 = DHT22.sensor(pi,16)
s14 = DHT22.sensor(pi,20)
s15 = DHT22.sensor(pi,21)



sensor_list = [s1, s2, s3, s4, s5, s6,s7,s8,s9,s10,s11,s12,s13,s14,s15]

## Create CSV File, Header
with open(hist_sensor_values_file_path, "w") as csvfile:
    tempwriter = csv.writer(csvfile, delimiter= ',')
    header_string = ['s1t', 's1h', 's1d', 's2t', 's2h', 's2d', 's3t', 's3h', 's3d', 's4t', 's4h', 's4d', 's5t', 's5h', 's5d', 's6t', 's6h', 's6d', 's7t', 's7h', 's7d', 's8t', 's8h', 's8d', 's9t', 's9h', 's9d', 's10t', 's10h', 's10d', 's11t', 's11h', 's11d', 's12t', 's12h', 's12d']
    tempwriter.writerow(header_string)

def query_sensors(sensor_list):
    # Collects temperature, humidity, and timestamp from each sensor once, appending them into a list and inserting it as a row in the csv file
    queried_data_list = []
    for sensor in sensor_list:
        sensor.trigger()
        time.sleep(0.3) # give the trigger time to collect data
        queried_data_list.extend(['{:3.2f}'.format(sensor.temperature() / 1.),'{:3.2f}'.format(sensor.humidity() / 1.), datetime.now().strftime("%Y/%m/%d %H:%M:%S")])

    with open(hist_sensor_values_file_path, "a") as csvfile:
        tempwriter = csv.writer(csvfile, delimiter= ',')
        tempwriter.writerow(queried_data_list)
        time.sleep(1) # have 1 second spacing between each sensor query
        
def update_git():
    os.system('git add .')
    os.system('git commit -m "committed' + datetime.now().strftime("%Y-%m-%d-%H-%M-%S") + '"')
    os.system('git push  https://BIOE4900github:a321987@github.com/BIOE4900github/BIOE4900github.git master')

def run_aeration_test(test_run_time, query_frequency):
    # run an aeration test, taking sensor queries every X minutes for Y minutes.
    end_time = time.time() + 60 * test_run_time

    while time.time() < end_time: #time.time() returns current time in seconds since Jan 1st, 1970
        query_sensors(sensor_list)
        update_git()
        time.sleep(60 * query_frequency)




run_aeration_test(4320,1)
