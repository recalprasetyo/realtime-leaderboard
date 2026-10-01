-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "events" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "location" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "marshals" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "event_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "marshals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "special_stages" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "event_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "special_stages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "classes" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "classes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "participants" (
    "id" UUID NOT NULL,
    "driver_name" TEXT NOT NULL,
    "driver_region" TEXT NOT NULL,
    "navigator_name" TEXT NOT NULL,
    "navigator_region" TEXT NOT NULL,
    "race_number" INTEGER NOT NULL,
    "team" TEXT NOT NULL,
    "class_id" UUID NOT NULL,
    "event_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "participants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stage_classes" (
    "id" UUID NOT NULL,
    "stage_id" UUID NOT NULL,
    "class_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "stage_classes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "starter_lists" (
    "id" UUID NOT NULL,
    "time_control" TIMESTAMP(3) NOT NULL,
    "participant_id" UUID NOT NULL,
    "stage_id" UUID NOT NULL,
    "event_id" UUID NOT NULL,
    "class_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "starter_lists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "race_records" (
    "id" UUID NOT NULL,
    "time" TIMESTAMP(3) NOT NULL,
    "point" INTEGER NOT NULL,
    "penalty_point" INTEGER NOT NULL,
    "participant_id" UUID NOT NULL,
    "marshal_id" UUID NOT NULL,
    "stage_id" UUID NOT NULL,
    "event_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "race_records_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "marshals_username_key" ON "marshals"("username");

-- CreateIndex
CREATE INDEX "marshals_event_id_idx" ON "marshals"("event_id");

-- CreateIndex
CREATE UNIQUE INDEX "marshals_id_event_id_key" ON "marshals"("id", "event_id");

-- CreateIndex
CREATE INDEX "special_stages_event_id_idx" ON "special_stages"("event_id");

-- CreateIndex
CREATE UNIQUE INDEX "special_stages_id_event_id_key" ON "special_stages"("id", "event_id");

-- CreateIndex
CREATE UNIQUE INDEX "classes_name_key" ON "classes"("name");

-- CreateIndex
CREATE INDEX "participants_event_id_class_id_idx" ON "participants"("event_id", "class_id");

-- CreateIndex
CREATE INDEX "participants_class_id_idx" ON "participants"("class_id");

-- CreateIndex
CREATE UNIQUE INDEX "participants_id_event_id_class_id_key" ON "participants"("id", "event_id", "class_id");

-- CreateIndex
CREATE INDEX "stage_classes_class_id_idx" ON "stage_classes"("class_id");

-- CreateIndex
CREATE UNIQUE INDEX "stage_classes_stage_id_class_id_key" ON "stage_classes"("stage_id", "class_id");

-- CreateIndex
CREATE INDEX "starter_lists_stage_id_time_control_idx" ON "starter_lists"("stage_id", "time_control");

-- CreateIndex
CREATE UNIQUE INDEX "starter_lists_participant_id_stage_id_key" ON "starter_lists"("participant_id", "stage_id");

-- CreateIndex
CREATE UNIQUE INDEX "starter_lists_participant_id_stage_id_event_id_key" ON "starter_lists"("participant_id", "stage_id", "event_id");

-- CreateIndex
CREATE INDEX "race_records_stage_id_created_at_idx" ON "race_records"("stage_id", "created_at");

-- CreateIndex
CREATE INDEX "race_records_participant_id_stage_id_event_id_idx" ON "race_records"("participant_id", "stage_id", "event_id");

-- CreateIndex
CREATE INDEX "race_records_marshal_id_event_id_idx" ON "race_records"("marshal_id", "event_id");

-- AddForeignKey
ALTER TABLE "marshals" ADD CONSTRAINT "marshals_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "special_stages" ADD CONSTRAINT "special_stages_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "participants" ADD CONSTRAINT "participants_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "participants" ADD CONSTRAINT "participants_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "stage_classes" ADD CONSTRAINT "stage_classes_stage_id_fkey" FOREIGN KEY ("stage_id") REFERENCES "special_stages"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "stage_classes" ADD CONSTRAINT "stage_classes_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "starter_lists" ADD CONSTRAINT "starter_lists_participant_fkey" FOREIGN KEY ("participant_id", "event_id", "class_id") REFERENCES "participants"("id", "event_id", "class_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "starter_lists" ADD CONSTRAINT "starter_lists_stage_event_fkey" FOREIGN KEY ("stage_id", "event_id") REFERENCES "special_stages"("id", "event_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "starter_lists" ADD CONSTRAINT "starter_lists_stage_class_fkey" FOREIGN KEY ("stage_id", "class_id") REFERENCES "stage_classes"("stage_id", "class_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "race_records" ADD CONSTRAINT "race_records_starter_fkey" FOREIGN KEY ("participant_id", "stage_id", "event_id") REFERENCES "starter_lists"("participant_id", "stage_id", "event_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "race_records" ADD CONSTRAINT "race_records_marshal_event_fkey" FOREIGN KEY ("marshal_id", "event_id") REFERENCES "marshals"("id", "event_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
