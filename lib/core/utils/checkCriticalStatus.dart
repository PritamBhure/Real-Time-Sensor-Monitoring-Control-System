/// ⚙️ BUSINESS LOGIC: Defines "Critical" limits for each machine type
bool checkCriticalStatus(String id, double value) {
  // Temperature: Alert if overheating (> 80°C)
  if (id.contains("TEMP")) return value > 80.0;

  // Pressure: Alert if pressure is too high (> 7.5 Bar)
  if (id.contains("PRES")) return value > 7.5;

  // Voltage: Alert if unstable (> 238V or < 222V)
  if (id.contains("VOLT")) return value > 238.0 || value < 222.0;

  // Vibration: Alert if shaking violently (> 4.0 mm/s)
  if (id.contains("VIBE")) return value > 4.0;

  // Flow: Alert if flow is clogged/low (< 42 LPM)
  if (id.contains("FLOW")) return value < 42.0;

  // Humidity: Alert if too moist (> 65%)
  if (id.contains("HUMI")) return value > 65.0;

  // Default Fallback
  return value > 90.0;
}



