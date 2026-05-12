-- Add session column if missing, journey_ref column, unique constraint, and auto-generation trigger
ALTER TABLE journeys ADD COLUMN IF NOT EXISTS session TEXT;
ALTER TABLE journeys ADD COLUMN IF NOT EXISTS journey_ref TEXT;

CREATE UNIQUE INDEX IF NOT EXISTS journeys_journey_ref_unique_idx ON journeys (journey_ref);

CREATE OR REPLACE FUNCTION generate_unique_journey_ref()
RETURNS TRIGGER AS $$
DECLARE
  normalized_session TEXT;
  next_index INTEGER;
  candidate_ref TEXT;
BEGIN
  IF NEW.journey_ref IS NULL OR NEW.journey_ref = '' THEN
    normalized_session := REGEXP_REPLACE(TRIM(COALESCE(NEW.session, 'UNKNOWN')), '\s+', '_', 'g');

    SELECT COALESCE(MAX(CAST(REGEXP_REPLACE(journey_ref, '^J-([0-9]{3}).*$', '\1') AS INTEGER)), 0) + 1
      INTO next_index
      FROM journeys
      WHERE journey_ref ~ '^J-[0-9]{3}';

    candidate_ref := 'J-' || LPAD(next_index::text, 3, '0') || '-' || normalized_session;

    WHILE EXISTS (SELECT 1 FROM journeys WHERE journey_ref = candidate_ref) LOOP
      next_index := next_index + 1;
      candidate_ref := 'J-' || LPAD(next_index::text, 3, '0') || '-' || normalized_session;
    END LOOP;

    NEW.journey_ref := candidate_ref;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS journeys_generate_ref ON journeys;
CREATE TRIGGER journeys_generate_ref
BEFORE INSERT ON journeys
FOR EACH ROW EXECUTE FUNCTION generate_unique_journey_ref();