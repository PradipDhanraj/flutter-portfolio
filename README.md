# myevents

==> Hnoss Project

## TODO: 
1. Set APNS for ios project.
2. Setup deeplinking for ios project.

## Table Schema

-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.wedding_event (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
  longitude double precision,
  title text NOT NULL DEFAULT ''::text,
  event_date date NOT NULL,
  payment_id text DEFAULT ''::text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  latitude double precision,
  owner_id text DEFAULT 'test_owner'::text,
  event_id text NOT NULL UNIQUE,
  imageUrl text DEFAULT ''::text,
  location character varying DEFAULT ''::character varying,
  username text DEFAULT ''::text,
  CONSTRAINT wedding_event_pkey PRIMARY KEY (id)
);


