-- Add missing columns to existing journeys table
ALTER TABLE journeys ADD COLUMN IF NOT EXISTS departure_location VARCHAR(255);
ALTER TABLE journeys ADD COLUMN IF NOT EXISTS departure_time TIMESTAMP;
ALTER TABLE journeys ADD COLUMN IF NOT EXISTS arrival_time TIMESTAMP;
ALTER TABLE journeys ADD COLUMN IF NOT EXISTS vehicle_id BIGINT REFERENCES vehicles(id) ON DELETE SET NULL;
ALTER TABLE journeys ADD COLUMN IF NOT EXISTS driver_id BIGINT REFERENCES drivers(id) ON DELETE SET NULL;
ALTER TABLE journeys ADD COLUMN IF NOT EXISTS personnel_ids TEXT;
ALTER TABLE journeys ADD COLUMN IF NOT EXISTS passenger_count INTEGER DEFAULT 0;
ALTER TABLE journeys ADD COLUMN IF NOT EXISTS vehicle_capacity INTEGER DEFAULT 0;
ALTER TABLE journeys ADD COLUMN IF NOT EXISTS status VARCHAR(50) DEFAULT 'Planned';

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_journeys_vehicle_id ON journeys(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_journeys_driver_id ON journeys(driver_id);
CREATE INDEX IF NOT EXISTS idx_journeys_status ON journeys(status);
CREATE INDEX IF NOT EXISTS idx_journeys_departure_time ON journeys(departure_time);