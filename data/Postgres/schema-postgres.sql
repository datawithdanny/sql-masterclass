CREATE SCHEMA trading;

CREATE TABLE trading.members (
  "member_id" VARCHAR(6),
  "first_name" VARCHAR(7),
  "region" VARCHAR(13)
);

CREATE TABLE trading.prices (
  "ticker" VARCHAR(3),
  "market_date" DATE,
  "price" FLOAT,
  "open" FLOAT,
  "high" FLOAT,
  "low" FLOAT,
  "volume" VARCHAR(7),
  "change" VARCHAR(7)
);

CREATE TABLE trading.transactions (
  "txn_id" INTEGER,
  "member_id" VARCHAR(6),
  "ticker" VARCHAR(3),
  "txn_date" DATE,
  "txn_type" VARCHAR(4),
  "quantity" FLOAT,
  "percentage_fee" FLOAT,
  "txn_time" TIMESTAMP
);

/*
-- Creating these indexes after loading data
-- will make things run much faster!!!

CREATE INDEX ON trading.prices (ticker, market_date);
CREATE INDEX ON trading.transactions (txn_date, ticker);
CREATE INDEX ON trading.transactions (txn_date, member_id);
CREATE INDEX ON trading.transactions (member_id);
CREATE INDEX ON trading.transactions (ticker);

*/