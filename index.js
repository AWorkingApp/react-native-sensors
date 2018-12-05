import sensors from "./src/sensors";
export { setUpdateInterval as setUpdateIntervalForType } from "./src/rnsensors";
export { start as startForType } from "./src/rnsensors";
export { stop as stopForType } from "./src/rnsensors";

export const SensorTypes = {
  accelerometer: "accelerometer",
  gyroscope: "gyroscope",
  magnetometer: "magnetometer",
  barometer: "barometer",
  deviceMotion: "deviceMotion"
};

export const { accelerometer, gyroscope, magnetometer, barometer, deviceMotion } = sensors;
export default sensors;
