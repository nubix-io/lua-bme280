print('Begin test')

local bme280 = require 'bme280'
local periphery = require 'periphery'

-- ============================================================================
-- Mini test framework
-- ============================================================================

local failures = 0

local function assertEquals(expected,actual,message)
  message = message or string.format('Expected %s but got %s', tostring(expected), tostring(actual))
  assert(actual==expected, message)
end

local function it(message, testFn)
  local status, err =  pcall(testFn)
  if status then
    print(string.format('✓ %s', message))
  else
    print(string.format('✖ %s', message))
    print(string.format('  FAILED: %s', err))
    failures = failures + 1
  end
end


-- ============================================================================
-- bme280 module
-- ============================================================================

it('getOversamplingRation', function()
  assertEquals(1, bme280.getOversamplingRation(bme280.AccuracyMode.ULTRA_LOW))
  assertEquals(2, bme280.getOversamplingRation(bme280.AccuracyMode.LOW))
  assertEquals(3, bme280.getOversamplingRation(bme280.AccuracyMode.STANDARD))
  assertEquals(4, bme280.getOversamplingRation(bme280.AccuracyMode.HIGH))
  assertEquals(5, bme280.getOversamplingRation(bme280.AccuracyMode.ULTRA_HIGH))
end)

it('readCoefficients', function()
  local I2C = periphery.I2C
  local i2c = I2C('/dev/i2c-1')
  local coeff = bme280.readCoefficients(i2c)
  assertEquals(true, coeff.dig_T1 > 0)
  assertEquals(true, coeff.dig_T2 > 0)
  assertEquals(true, coeff.dig_T3 > 0)
end) 
 
it('readHumidityRH', function()
  local I2C = periphery.I2C
  local i2c = I2C('/dev/i2c-1')
  local coeff = bme280.readCoefficients(i2c)
  local hum = bme280.readHumidityRH(i2c, bme280.AccuracyMode.STANDARD, coeff)
  assertEquals(true, hum > 0)
end) 

it('readPressurePa', function()
  local I2C = periphery.I2C
  local i2c = I2C('/dev/i2c-1')
  local coeff = bme280.readCoefficients(i2c)
  local press = bme280.readPressurePa(i2c, bme280.AccuracyMode.STANDARD, coeff)
  assertEquals(true, press > 0)
end) 

it('readSensorID', function()
  local I2C = periphery.I2C
  local i2c = I2C('/dev/i2c-1')
  local sensorID = bme280.readSensorID(i2c)
  assertEquals(0x60, sensorID)
end) 

it('readTemperatureC', function()
  local I2C = periphery.I2C
  local i2c = I2C('/dev/i2c-1')
  local coeff = bme280.readCoefficients(i2c)
  local temp = bme280.readTemperatureC(i2c, bme280.AccuracyMode.STANDARD, coeff)
  assertEquals(true, temp > 0)
end) 

it('readUncompensatedHumidity', function()
  local I2C = periphery.I2C
  local i2c = I2C('/dev/i2c-1')
  local hum = bme280.readUncompensatedHumidity(i2c, bme280.AccuracyMode.STANDARD)
  assertEquals(true, hum > 0)
end) 

it('readUncompensatedPressure', function()
  local I2C = periphery.I2C
  local i2c = I2C('/dev/i2c-1')
  local press = bme280.readUncompensatedPressure(i2c, bme280.AccuracyMode.STANDARD)
  assertEquals(true, press > 0)
end) 

it('readUncompensatedTemperature', function()
  local I2C = periphery.I2C
  local i2c = I2C('/dev/i2c-1')
  local temp = bme280.readUncompensatedTemperature(i2c, bme280.AccuracyMode.STANDARD)
  assertEquals(true, temp > 0)
end) 

it('readUncompensatedTemperatureAndPressure', function()
  local I2C = periphery.I2C
  local i2c = I2C('/dev/i2c-1')
  local temp, press = bme280.readUncompensatedTemperatureAndPressure(i2c, bme280.AccuracyMode.STANDARD)
  assertEquals(true, temp > 0)
  assertEquals(true, press > 0)
end) 

it('readUShort', function()
  local msb, lsb = 109, 231
  assertEquals(28135, bme280.readUShort(lsb, msb))
end) 

it('readShort', function()
  local msb, lsb = 215, 84
  assertEquals(-10412, bme280.readShort(lsb, msb))
end) 
