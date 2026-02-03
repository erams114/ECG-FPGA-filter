import serial

ser = serial.Serial(
        port = "COM ",
        baudrate = 9600
        )

with open("InputSignal.txt", "r") as file
    for line in file:
        ser.write(line.encode())
        
        
if ser.in_waiting:
    received_data = ser.read(ser.in_waiting).decode()
    print(f"Received: {received_data}")
    
ser.close



