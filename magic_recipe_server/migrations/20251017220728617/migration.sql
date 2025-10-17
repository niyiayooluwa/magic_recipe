BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "recipe" ADD COLUMN "userId" bigint;

--
-- MIGRATION VERSION FOR magic_recipe
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('magic_recipe', '20251017220728617', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251017220728617', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
