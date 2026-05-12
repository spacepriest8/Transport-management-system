-- Add journey column to the personnel table if it does not already exist
ALTER TABLE personnel
ADD COLUMN IF NOT EXISTS journey TEXT;
