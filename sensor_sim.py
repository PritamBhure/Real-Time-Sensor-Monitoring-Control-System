import asyncio
import websockets
import json
import random
import datetime

async def simulate_sensors(websocket):
    print("Flutter App Connected!")
    sensor_ids = ["TEMP_01", "PRES_02", "VOLT_03", "VIBE_04", "FLOW_05", "HUMI_06"]
    
    try:
        while True:
            for sensor_id in sensor_ids:
                # Initialize default values
                value = 0.0
                unit = ""

                # Assign specific Units and Realistic Ranges based on ID
                if "TEMP" in sensor_id:
                    unit = "°C"
                    value = random.uniform(35.0, 85.0) # Typical machine running temp
                elif "PRES" in sensor_id:
                    unit = "Bar"
                    value = random.uniform(2.5, 8.0)   # Industrial pressure
                elif "VOLT" in sensor_id:
                    unit = "V"
                    value = random.uniform(220.0, 240.0) # Standard Mains Voltage
                elif "VIBE" in sensor_id:
                    unit = "mm/s"
                    value = random.uniform(0.1, 5.0)   # Vibration velocity (ISO standard)
                elif "FLOW" in sensor_id:
                    unit = "LPM"
                    value = random.uniform(40.0, 60.0) # Liters Per Minute
                elif "HUMI" in sensor_id:
                    unit = "%"
                    value = random.uniform(30.0, 70.0) # Humidity percentage
                
                data = {
                    "id": sensor_id,
                    "value": round(value, 2),
                    "unit": unit,
                    "timestamp": datetime.datetime.now().isoformat()
                }
                
                # Send to Flutter
                await websocket.send(json.dumps(data))
                await asyncio.sleep(0.05) # Slight delay between individual sensor packets
            
            print("Sent batch update...")
            await asyncio.sleep(1) # Wait 1 second before next full batch update
            
    except websockets.exceptions.ConnectionClosed:
        print("Flutter App Disconnected")

async def main():
    async with websockets.serve(simulate_sensors, "0.0.0.0", 8080):
        print("Sensor Simulator running on ws://0.0.0.0:8080")
        await asyncio.get_running_loop().create_future() 

if __name__ == "__main__":
    asyncio.run(main())