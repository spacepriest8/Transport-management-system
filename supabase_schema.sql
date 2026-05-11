-- PERSONNEL TABLE
CREATE TABLE IF NOT EXISTS personnel (
  id BIGSERIAL PRIMARY KEY,
  emp_number VARCHAR(50) UNIQUE NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  dept VARCHAR(100),
  clearance VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- VEHICLES TABLE
CREATE TABLE IF NOT EXISTS vehicles (
  id BIGSERIAL PRIMARY KEY,
  bus_number VARCHAR(50) UNIQUE NOT NULL,
  plate VARCHAR(50) UNIQUE NOT NULL,
  type VARCHAR(100),
  capacity INTEGER,
  status VARCHAR(50) DEFAULT 'Active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DRIVERS TABLE
CREATE TABLE IF NOT EXISTS drivers (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  contact VARCHAR(20),
  license_number VARCHAR(50) UNIQUE NOT NULL,
  availability VARCHAR(50) DEFAULT 'Available',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- JOURNEYS TABLE
CREATE TABLE IF NOT EXISTS journeys (
  id BIGSERIAL PRIMARY KEY,
  journey_ref VARCHAR(100) UNIQUE NOT NULL,
  departure_location VARCHAR(255),
  destination VARCHAR(255),
  departure_time TIMESTAMP,
  arrival_time TIMESTAMP,
  vehicle_id BIGINT REFERENCES vehicles(id) ON DELETE SET NULL,
  driver_id BIGINT REFERENCES drivers(id) ON DELETE SET NULL,
  personnel_ids TEXT,
  passenger_count INTEGER DEFAULT 0,
  vehicle_capacity INTEGER DEFAULT 0,
  status VARCHAR(50) DEFAULT 'Planned',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_journeys_vehicle_id ON journeys(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_journeys_driver_id ON journeys(driver_id);
CREATE INDEX IF NOT EXISTS idx_journeys_status ON journeys(status);
CREATE INDEX IF NOT EXISTS idx_journeys_departure_time ON journeys(departure_time);

-- Enable Row Level Security (RLS)
ALTER TABLE personnel ENABLE ROW LEVEL SECURITY;
ALTER TABLE vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE drivers ENABLE ROW LEVEL SECURITY;
ALTER TABLE journeys ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Allow all users to read
CREATE POLICY "Allow read access to personnel" ON personnel FOR SELECT USING (true);
CREATE POLICY "Allow read access to vehicles" ON vehicles FOR SELECT USING (true);
CREATE POLICY "Allow read access to drivers" ON drivers FOR SELECT USING (true);
CREATE POLICY "Allow read access to journeys" ON journeys FOR SELECT USING (true);

-- RLS Policy: Allow all users to insert
CREATE POLICY "Allow insert to personnel" ON personnel FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow insert to vehicles" ON vehicles FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow insert to drivers" ON drivers FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow insert to journeys" ON journeys FOR INSERT WITH CHECK (true);

-- RLS Policy: Allow all users to update
CREATE POLICY "Allow update to personnel" ON personnel FOR UPDATE USING (true);
CREATE POLICY "Allow update to vehicles" ON vehicles FOR UPDATE USING (true);
CREATE POLICY "Allow update to drivers" ON drivers FOR UPDATE USING (true);
CREATE POLICY "Allow update to journeys" ON journeys FOR UPDATE USING (true);

-- RLS Policy: Allow all users to delete
CREATE POLICY "Allow delete from personnel" ON personnel FOR DELETE USING (true);
CREATE POLICY "Allow delete from vehicles" ON vehicles FOR DELETE USING (true);
CREATE POLICY "Allow delete from drivers" ON drivers FOR DELETE USING (true);
CREATE POLICY "Allow delete from journeys" ON journeys FOR DELETE USING (true);
