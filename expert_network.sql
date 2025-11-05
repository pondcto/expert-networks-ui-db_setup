/*
 Navicat Premium Dump SQL

 Source Server         : postgres
 Source Server Type    : PostgreSQL
 Source Server Version : 130022 (130022)
 Source Host           : localhost:5432
 Source Catalog        : ragdb
 Source Schema         : expert_network

 Target Server Type    : PostgreSQL
 Target Server Version : 130022 (130022)
 File Encoding         : 65001

 Date: 04/11/2025 19:31:26
*/


-- ----------------------------
-- Table structure for campaign_team_assignments
-- ----------------------------
DROP TABLE IF EXISTS "expert_network"."campaign_team_assignments";
CREATE TABLE "expert_network"."campaign_team_assignments" (
  "campaign_id" uuid NOT NULL,
  "team_member_id" uuid NOT NULL,
  "assigned_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of campaign_team_assignments
-- ----------------------------
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('56173be4-49a7-4266-9eac-07114c2007a8', 'f2bd664f-8432-4939-85ff-833e9c95e61f', '2025-11-04 18:15:59.647797-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('56173be4-49a7-4266-9eac-07114c2007a8', 'f658da5e-5c1d-4072-99bb-5830d189e240', '2025-11-04 18:16:02.740949-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('56173be4-49a7-4266-9eac-07114c2007a8', 'd211ac2c-1e38-4b20-bf67-7732295ae876', '2025-11-04 18:21:57.774249-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('56173be4-49a7-4266-9eac-07114c2007a8', 'd0475de5-cc9a-4af5-b14b-bd87f494214e', '2025-11-04 18:21:59.349172-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('56173be4-49a7-4266-9eac-07114c2007a8', '6f1c8767-c3a8-4f62-b89c-46b8a3c718d5', '2025-11-04 18:22:21.320714-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('56173be4-49a7-4266-9eac-07114c2007a8', '302ae419-dd30-4f07-95ea-a8246a139e43', '2025-11-04 18:22:23.739667-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'f2bd664f-8432-4939-85ff-833e9c95e61f', '2025-11-04 18:24:19.789244-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('08036cdf-9e42-4bfa-9d4a-2d580bf1f879', '302ae419-dd30-4f07-95ea-a8246a139e43', '2025-11-04 18:24:20.651261-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'f658da5e-5c1d-4072-99bb-5830d189e240', '2025-11-04 18:24:21.24508-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'd0475de5-cc9a-4af5-b14b-bd87f494214e', '2025-11-04 18:24:21.850806-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('bead487a-b8b1-420f-8bca-ee4983b37559', 'd211ac2c-1e38-4b20-bf67-7732295ae876', '2025-11-04 18:24:28.116696-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('bead487a-b8b1-420f-8bca-ee4983b37559', 'bc55d0b8-d800-4e3c-949c-59943b9917b5', '2025-11-04 18:24:28.884635-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('bead487a-b8b1-420f-8bca-ee4983b37559', 'f658da5e-5c1d-4072-99bb-5830d189e240', '2025-11-04 18:24:34.371648-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'f2bd664f-8432-4939-85ff-833e9c95e61f', '2025-11-04 18:24:40.651882-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'bc55d0b8-d800-4e3c-949c-59943b9917b5', '2025-11-04 18:24:41.259573-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', '6f1c8767-c3a8-4f62-b89c-46b8a3c718d5', '2025-11-04 18:24:41.828346-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', '302ae419-dd30-4f07-95ea-a8246a139e43', '2025-11-04 18:24:42.667443-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'f658da5e-5c1d-4072-99bb-5830d189e240', '2025-11-04 18:24:43.196278-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'd211ac2c-1e38-4b20-bf67-7732295ae876', '2025-11-04 18:24:43.610521-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'd0475de5-cc9a-4af5-b14b-bd87f494214e', '2025-11-04 18:24:44.332051-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', '1344cf99-0cd4-41c7-88bd-892c16200480', '2025-11-04 18:24:44.898723-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'bc55d0b8-d800-4e3c-949c-59943b9917b5', '2025-11-04 18:24:51.555747-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('31faa8b0-17b3-4c8e-8e8b-872016687e2b', '6f1c8767-c3a8-4f62-b89c-46b8a3c718d5', '2025-11-04 18:24:52.300909-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'd0475de5-cc9a-4af5-b14b-bd87f494214e', '2025-11-04 18:24:52.89947-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('31faa8b0-17b3-4c8e-8e8b-872016687e2b', '1344cf99-0cd4-41c7-88bd-892c16200480', '2025-11-04 18:24:53.452133-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('31faa8b0-17b3-4c8e-8e8b-872016687e2b', '302ae419-dd30-4f07-95ea-a8246a139e43', '2025-11-04 18:24:54.026904-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('32f3acce-0f98-440d-a295-c48c64acfc46', 'd0475de5-cc9a-4af5-b14b-bd87f494214e', '2025-11-04 18:25:02.355683-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('32f3acce-0f98-440d-a295-c48c64acfc46', '302ae419-dd30-4f07-95ea-a8246a139e43', '2025-11-04 18:25:03.180274-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('32f3acce-0f98-440d-a295-c48c64acfc46', '6f1c8767-c3a8-4f62-b89c-46b8a3c718d5', '2025-11-04 18:25:03.70806-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('32f3acce-0f98-440d-a295-c48c64acfc46', 'f658da5e-5c1d-4072-99bb-5830d189e240', '2025-11-04 18:25:04.267238-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'f658da5e-5c1d-4072-99bb-5830d189e240', '2025-11-04 18:25:09.579906-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('6065f0bf-c71b-4359-ae93-c6f8dd514c87', '6f1c8767-c3a8-4f62-b89c-46b8a3c718d5', '2025-11-04 18:25:10.324305-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('6065f0bf-c71b-4359-ae93-c6f8dd514c87', '302ae419-dd30-4f07-95ea-a8246a139e43', '2025-11-04 18:25:11.244525-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'd0475de5-cc9a-4af5-b14b-bd87f494214e', '2025-11-04 18:25:12.052738-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('fc37dc29-986b-4481-8db9-665cfb80c8cb', 'bc55d0b8-d800-4e3c-949c-59943b9917b5', '2025-11-04 18:25:17.634966-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('fc37dc29-986b-4481-8db9-665cfb80c8cb', '6f1c8767-c3a8-4f62-b89c-46b8a3c718d5', '2025-11-04 18:25:18.372735-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('fc37dc29-986b-4481-8db9-665cfb80c8cb', '1344cf99-0cd4-41c7-88bd-892c16200480', '2025-11-04 18:25:19.034998-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('fc37dc29-986b-4481-8db9-665cfb80c8cb', 'd0475de5-cc9a-4af5-b14b-bd87f494214e', '2025-11-04 18:25:19.6048-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('440b5bab-93b9-4f14-a9e7-66419fcde59d', 'f2bd664f-8432-4939-85ff-833e9c95e61f', '2025-11-04 18:25:25.43668-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('440b5bab-93b9-4f14-a9e7-66419fcde59d', 'f658da5e-5c1d-4072-99bb-5830d189e240', '2025-11-04 18:25:26.211486-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('440b5bab-93b9-4f14-a9e7-66419fcde59d', 'd211ac2c-1e38-4b20-bf67-7732295ae876', '2025-11-04 18:25:27.03541-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('440b5bab-93b9-4f14-a9e7-66419fcde59d', '6f1c8767-c3a8-4f62-b89c-46b8a3c718d5', '2025-11-04 18:25:27.611981-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('440b5bab-93b9-4f14-a9e7-66419fcde59d', 'd0475de5-cc9a-4af5-b14b-bd87f494214e', '2025-11-04 18:25:28.138562-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('7d9fc3aa-827e-4329-97b4-d9c6664aa510', '302ae419-dd30-4f07-95ea-a8246a139e43', '2025-11-04 18:25:34.477023-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'd211ac2c-1e38-4b20-bf67-7732295ae876', '2025-11-04 18:25:35.107719-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('7d9fc3aa-827e-4329-97b4-d9c6664aa510', '1344cf99-0cd4-41c7-88bd-892c16200480', '2025-11-04 18:25:35.891242-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'd0475de5-cc9a-4af5-b14b-bd87f494214e', '2025-11-04 18:25:36.804014-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'f658da5e-5c1d-4072-99bb-5830d189e240', '2025-11-04 18:25:37.691788-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'd211ac2c-1e38-4b20-bf67-7732295ae876', '2025-11-04 18:25:45.115961-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('34b4a0fc-259e-4c35-8ef5-f525af6232ff', '6f1c8767-c3a8-4f62-b89c-46b8a3c718d5', '2025-11-04 18:25:45.794897-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('34b4a0fc-259e-4c35-8ef5-f525af6232ff', '302ae419-dd30-4f07-95ea-a8246a139e43', '2025-11-04 18:25:46.338298-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'bc55d0b8-d800-4e3c-949c-59943b9917b5', '2025-11-04 18:25:47.283592-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('32f3acce-0f98-440d-a295-c48c64acfc46', 'f2bd664f-8432-4939-85ff-833e9c95e61f', '2025-11-04 18:55:36.072992-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('504b545e-9bef-4694-a176-67feec23ba06', 'f2bd664f-8432-4939-85ff-833e9c95e61f', '2025-11-04 19:07:44.109462-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('504b545e-9bef-4694-a176-67feec23ba06', 'd211ac2c-1e38-4b20-bf67-7732295ae876', '2025-11-04 19:07:44.1544-05');
INSERT INTO "expert_network"."campaign_team_assignments" VALUES ('504b545e-9bef-4694-a176-67feec23ba06', '302ae419-dd30-4f07-95ea-a8246a139e43', '2025-11-04 19:07:44.21016-05');

-- ----------------------------
-- Table structure for campaign_vendor_enrollments
-- ----------------------------
DROP TABLE IF EXISTS "expert_network"."campaign_vendor_enrollments";
CREATE TABLE "expert_network"."campaign_vendor_enrollments" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "campaign_id" uuid NOT NULL,
  "vendor_platform_id" uuid NOT NULL,
  "status" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'pending'::text,
  "enrolled_at" timestamptz(6),
  "account_manager_name" text COLLATE "pg_catalog"."default",
  "account_manager_email" text COLLATE "pg_catalog"."default",
  "notes" text COLLATE "pg_catalog"."default",
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "updated_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of campaign_vendor_enrollments
-- ----------------------------
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('911d9162-2723-4688-b245-8c41329c8713', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'd4e5f6a7-b8c9-4123-d567-890123defabc', 'pending', NULL, 'Manager 2', 'manager2@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('ecf7d947-b252-4143-9167-868bb79d60b9', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'e5f6a7b8-c9d0-4234-e678-901234efabcd', 'pending', NULL, 'Manager 3', 'manager3@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('5b3d5ee3-5666-4749-93c9-3637cf812a8d', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'f6a7b8c9-d0e1-4345-f789-012345fabcde', 'pending', NULL, 'Manager 4', 'manager4@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('6a3bda3d-448a-4e36-88f0-00363fd7d33a', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'a7b8c9d0-e1f2-4456-a890-123456abcdef', 'enrolled', '2025-10-31 18:04:56.028923-04', 'Manager 3', 'manager3@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('a2884e72-e807-4ec1-8d35-a66f173efe99', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'b8c9d0e1-f2a3-4567-b901-234567bcdefb', 'enrolled', '2025-10-31 18:04:56.028923-04', 'Manager 4', 'manager4@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('5c5b8eb0-fb5f-4fd3-86dd-61503109f98e', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'c9d0e1f2-a3b4-4678-c012-345678cdefab', 'enrolled', '2025-10-31 18:04:56.028923-04', 'Manager 5', 'manager5@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('71580578-9ff9-4341-a9e1-5c2f1a11b658', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'd0e1f2a3-b4c5-4789-d123-456789defabc', 'enrolled', '2025-10-31 18:04:56.028923-04', 'Manager 6', 'manager6@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('fc0535fc-8357-41ba-aed1-f5e8bb4ef284', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'd0e1f2a3-b4c5-4789-d123-456789defabc', 'enrolled', '2025-10-29 18:04:56.028923-04', 'Manager 4', 'manager4@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('c9a21e10-e660-49fc-b392-2671e5008cb9', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'e1f2a3b4-c5d6-4890-e234-567890efabcd', 'enrolled', '2025-10-29 18:04:56.028923-04', 'Manager 5', 'manager5@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('c2878910-a6b1-4f14-a285-796f019c1587', '32f3acce-0f98-440d-a295-c48c64acfc46', 'a3b4c5d6-e7f8-4012-a456-789012abcdef', 'pending', NULL, 'Manager 5', 'manager5@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('20a938d9-4cf8-4b40-b367-3f4da66202f4', '32f3acce-0f98-440d-a295-c48c64acfc46', 'b4c5d6e7-f8a9-4123-b567-890123bcdefb', 'pending', NULL, 'Manager 6', 'manager6@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('a12fb0df-8a46-4cae-a2be-337751a5bdc0', '32f3acce-0f98-440d-a295-c48c64acfc46', 'c5d6e7f8-a9b0-4234-c678-901234cdefab', 'pending', NULL, 'Manager 7', 'manager7@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('ff67452c-5d0d-441e-bffd-0557bed99390', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'd6e7f8a9-b0c1-4345-d789-012345defabc', 'enrolled', '2025-10-25 18:04:56.028923-04', 'Manager 6', 'manager6@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('c866cc37-951d-4f99-a0e3-ec5ffcc90dab', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'e7f8a9b0-c1d2-4456-e890-123456efabcd', 'enrolled', '2025-10-25 18:04:56.028923-04', 'Manager 7', 'manager7@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('88db042c-a177-4ca8-a952-f0e82b4533ff', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b', 'enrolled', '2025-10-25 18:04:56.028923-04', 'Manager 8', 'manager8@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('81151818-ca75-4a40-af25-448bc1bcb2bc', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'a1b2c3d4-e5f6-4789-a123-567890abcdef', 'enrolled', '2025-10-25 18:04:56.028923-04', 'Manager 9', 'manager9@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('fbcbfe9d-c48c-4d1e-aff0-266a1943a513', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', 'a1b2c3d4-e5f6-4789-a123-567890abcdef', 'enrolled', '2025-10-23 18:04:56.028923-04', 'Manager 7', 'manager7@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('51fb0b76-4b31-4378-8fd0-45729279a7ab', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', 'b2c3d4e5-f6a7-4801-b345-678901bcdefb', 'enrolled', '2025-10-23 18:04:56.028923-04', 'Manager 8', 'manager8@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('29b6d247-2d7f-44cc-b306-2f8cd7d3ceb3', '56173be4-49a7-4266-9eac-07114c2007a8', 'd4e5f6a7-b8c9-4123-d567-890123defabc', 'pending', NULL, 'Manager 8', 'manager8@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('c59f9d40-f184-4412-962f-551d83bd9be0', '56173be4-49a7-4266-9eac-07114c2007a8', 'e5f6a7b8-c9d0-4234-e678-901234efabcd', 'pending', NULL, 'Manager 9', 'manager9@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('9031d7d6-ac88-4ca6-831e-9fe93f1ce897', '56173be4-49a7-4266-9eac-07114c2007a8', 'f6a7b8c9-d0e1-4345-f789-012345fabcde', 'pending', NULL, 'Manager 10', 'manager10@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('655d2097-fb84-4f8a-a2a7-dbbbf44003fa', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'a7b8c9d0-e1f2-4456-a890-123456abcdef', 'enrolled', '2025-10-19 18:04:56.028923-04', 'Manager 9', 'manager9@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('7e7c4e80-12f0-4aa8-9cae-df8f68828a9a', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'b8c9d0e1-f2a3-4567-b901-234567bcdefb', 'enrolled', '2025-10-19 18:04:56.028923-04', 'Manager 10', 'manager10@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('378e2d61-dfdd-41f3-b537-dc2fd64cc757', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'c9d0e1f2-a3b4-4678-c012-345678cdefab', 'enrolled', '2025-10-19 18:04:56.028923-04', 'Manager 11', 'manager11@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('4580e586-ee02-4655-9e0a-d24c80c4c760', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'd0e1f2a3-b4c5-4789-d123-456789defabc', 'enrolled', '2025-10-19 18:04:56.028923-04', 'Manager 12', 'manager12@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('855f1d8f-c02d-4b8f-afc4-7e93b9e92409', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'd0e1f2a3-b4c5-4789-d123-456789defabc', 'enrolled', '2025-10-17 18:04:56.028923-04', 'Manager 10', 'manager10@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('85f76a15-0463-42ae-aebb-a7986c1a4511', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'e1f2a3b4-c5d6-4890-e234-567890efabcd', 'enrolled', '2025-10-17 18:04:56.028923-04', 'Manager 11', 'manager11@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('5b13fed8-6bde-482b-92c9-f13f38f2ffeb', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'a3b4c5d6-e7f8-4012-a456-789012abcdef', 'pending', NULL, 'Manager 11', 'manager11@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('412b4f06-6cf8-4774-a4a8-33a1bc319fec', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'b4c5d6e7-f8a9-4123-b567-890123bcdefb', 'pending', NULL, 'Manager 12', 'manager12@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('d2e4114d-f5b2-47d0-8cdb-61621bafb3a4', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'c5d6e7f8-a9b0-4234-c678-901234cdefab', 'pending', NULL, 'Manager 13', 'manager13@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('8fa76544-bc6f-4405-a2e2-59900962bde0', 'bead487a-b8b1-420f-8bca-ee4983b37559', 'd6e7f8a9-b0c1-4345-d789-012345defabc', 'enrolled', '2025-10-13 18:04:56.028923-04', 'Manager 12', 'manager12@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('d851852e-d0b3-4f3c-aed8-56eb65bebef2', 'bead487a-b8b1-420f-8bca-ee4983b37559', 'e7f8a9b0-c1d2-4456-e890-123456efabcd', 'enrolled', '2025-10-13 18:04:56.028923-04', 'Manager 13', 'manager13@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('fbd30244-13bc-44c2-b284-a70204488176', 'bead487a-b8b1-420f-8bca-ee4983b37559', 'e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b', 'enrolled', '2025-10-13 18:04:56.028923-04', 'Manager 14', 'manager14@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('ca928f22-ff63-47b0-bbc0-8fa945a24e01', 'bead487a-b8b1-420f-8bca-ee4983b37559', 'a1b2c3d4-e5f6-4789-a123-567890abcdef', 'enrolled', '2025-10-13 18:04:56.028923-04', 'Manager 15', 'manager15@vendor.com', NULL, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."campaign_vendor_enrollments" VALUES ('9c434117-d2da-4536-8ac7-f1c1fa561331', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'a3b4c5d6-e7f8-4012-a456-789012abcdef', 'pending', NULL, NULL, NULL, NULL, '2025-11-04 18:16:29.374476-05', '2025-11-04 18:16:29.374476-05');

-- ----------------------------
-- Table structure for campaigns
-- ----------------------------
DROP TABLE IF EXISTS "expert_network"."campaigns";
CREATE TABLE "expert_network"."campaigns" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "project_id" uuid,
  "campaign_name" text COLLATE "pg_catalog"."default" NOT NULL,
  "industry_vertical" text COLLATE "pg_catalog"."default" NOT NULL,
  "custom_industry" text COLLATE "pg_catalog"."default",
  "brief_description" text COLLATE "pg_catalog"."default",
  "expanded_description" text COLLATE "pg_catalog"."default",
  "start_date" date NOT NULL,
  "target_completion_date" date NOT NULL,
  "target_regions" text[] COLLATE "pg_catalog"."default" NOT NULL DEFAULT '{}'::text[],
  "custom_regions" text COLLATE "pg_catalog"."default",
  "min_calls" int4,
  "max_calls" int4,
  "estimated_calls" int4,
  "completed_calls" int4 NOT NULL DEFAULT 0,
  "scheduled_calls" int4 NOT NULL DEFAULT 0,
  "display_order" int4 NOT NULL DEFAULT 0,
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "updated_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "expert_network"."campaigns"."custom_regions" IS 'Custom region specification when "Other" is selected for target regions';
COMMENT ON TABLE "expert_network"."campaigns" IS 'Interview campaigns for commercial diligence projects';

-- ----------------------------
-- Records of campaigns
-- ----------------------------
INSERT INTO "expert_network"."campaigns" VALUES ('7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'demo-user-123', '1e7cf7f2-8806-4677-b372-7fe4df58d29e', 'Battery Storage Technology', 'Energy', NULL, 'Expert insights on battery storage solutions', 'Deep dive into battery storage technology for renewable energy, including lithium-ion, flow batteries, and emerging technologies. Focus on grid-scale storage and commercial applications.', '2025-10-27', '2025-12-12', '{"North America","Asia Pacific"}', NULL, 10, 20, NULL, 0, 0, 9, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:45:25.400421-05');
INSERT INTO "expert_network"."campaigns" VALUES ('08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'demo-user-123', 'f56fd925-8893-41eb-a877-e2d0d9fd80d8', 'Clinical AI Implementation', 'Healthcare', NULL, 'Expert interviews on clinical AI adoption in hospitals', 'Comprehensive research on how major healthcare systems are implementing AI for clinical decision support, diagnostic imaging, and patient care optimization. Focus on real-world deployment challenges, ROI metrics, and clinical outcomes.', '2025-10-05', '2026-01-03', '{"North America",Europe}', NULL, 15, 25, NULL, 0, 0, 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:45:25.40166-05');
INSERT INTO "expert_network"."campaigns" VALUES ('34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'demo-user-123', 'b4957e3a-df1b-4371-a1a4-0332f4ce15ac', 'Zero Trust Architecture', 'Technology', NULL, 'Expert interviews on zero trust security', 'Comprehensive research on zero trust security architecture, including implementation strategies, vendor landscape, and best practices for enterprise adoption.', '2025-10-21', '2025-12-18', '{"North America",Europe}', NULL, 16, 26, NULL, 0, 0, 10, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:49:39.464235-05');
INSERT INTO "expert_network"."campaigns" VALUES ('bead487a-b8b1-420f-8bca-ee4983b37559', 'demo-user-123', 'f56fd925-8893-41eb-a877-e2d0d9fd80d8', 'AI in Medical Imaging', 'Healthcare', NULL, 'Expert insights on AI-powered diagnostic imaging', 'Research on AI applications in radiology, pathology, and medical imaging. Explore vendor landscape, accuracy improvements, regulatory considerations, and integration challenges with existing PACS systems.', '2025-10-15', '2025-12-19', '{"North America"}', NULL, 10, 20, NULL, 0, 0, 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:45:25.390196-05');
INSERT INTO "expert_network"."campaigns" VALUES ('32f3acce-0f98-440d-a295-c48c64acfc46', 'demo-user-123', '3b741b39-e352-4538-a71f-4b3ac69bc5b1', 'Cryptocurrency Regulatory Landscape', 'Finance', NULL, 'Expert insights on crypto regulations', 'Comprehensive analysis of cryptocurrency and DeFi regulations across major markets. Focus on SEC, CFTC, and EU regulatory frameworks, compliance requirements, and future regulatory trends.', '2025-10-20', '2025-12-14', '{"North America","Asia Pacific"}', NULL, 8, 18, NULL, 0, 0, 3, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:45:25.402452-05');
INSERT INTO "expert_network"."campaigns" VALUES ('31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'demo-user-123', '637bd937-e34d-43a2-bd4e-2be3ae93d19e', 'Enterprise Sales Motion', 'Technology', NULL, 'Expert insights on enterprise sales processes', 'Deep dive into enterprise sales motions, including account-based marketing, sales enablement, customer success, and expansion strategies. Focus on B2B SaaS companies with $10M+ ARR.', '2025-10-30', '2025-12-04', '{"North America",Europe}', NULL, 15, 25, NULL, 0, 0, 5, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:45:25.404135-05');
INSERT INTO "expert_network"."campaigns" VALUES ('6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'demo-user-123', '4167ef44-05b0-43b1-94f0-c594e2aeabc3', 'Global Supply Chain Disruption', 'Manufacturing', NULL, 'Expert interviews on supply chain challenges', 'Research on global supply chain disruptions, including logistics bottlenecks, supplier diversification strategies, nearshoring trends, and technology solutions for supply chain visibility.', '2025-10-15', '2025-12-29', '{"North America","Asia Pacific",Europe}', NULL, 20, 30, NULL, 0, 0, 6, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:45:25.404864-05');
INSERT INTO "expert_network"."campaigns" VALUES ('56173be4-49a7-4266-9eac-07114c2007a8', 'demo-user-123', '637bd937-e34d-43a2-bd4e-2be3ae93d19e', 'SaaS Pricing Models', 'Technology', NULL, 'Expert interviews on enterprise SaaS pricing strategies', 'Research on enterprise SaaS pricing models, value-based pricing, usage-based pricing, and competitive positioning. Expert insights from SaaS executives and pricing strategy consultants.', '2025-10-25', '2025-12-09', '{"North America"}', NULL, 10, 20, NULL, 0, 0, 4, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:45:25.405649-05');
INSERT INTO "expert_network"."campaigns" VALUES ('440b5bab-93b9-4f14-a9e7-66419fcde59d', 'demo-user-123', '1e7cf7f2-8806-4677-b372-7fe4df58d29e', 'Solar Energy Market Dynamics', 'Energy', NULL, 'Expert interviews on solar energy adoption', 'Research on solar energy market dynamics, including panel technology trends, installation economics, grid integration challenges, and policy impacts. Focus on residential and commercial solar markets.', '2025-10-17', '2025-12-22', '{"North America",Europe}', NULL, 14, 24, NULL, 0, 0, 8, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:45:25.40622-05');
INSERT INTO "expert_network"."campaigns" VALUES ('fc37dc29-986b-4481-8db9-665cfb80c8cb', 'demo-user-123', '4167ef44-05b0-43b1-94f0-c594e2aeabc3', 'Supply Chain Technology Stack', 'Manufacturing', NULL, 'Expert insights on supply chain technology', 'Comprehensive analysis of supply chain technology platforms, including warehouse management systems, transportation management systems, demand forecasting, and IoT integration.', '2025-10-23', '2025-12-16', '{"North America",Europe}', NULL, 12, 22, NULL, 0, 0, 7, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:45:25.406804-05');
INSERT INTO "expert_network"."campaigns" VALUES ('09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'demo-user-123', '3b741b39-e352-4538-a71f-4b3ac69bc5b1', 'Digital Banking Regulations', 'Finance', NULL, 'Expert interviews on digital banking compliance', 'Deep dive into regulatory requirements for digital banking platforms, including KYC/AML compliance, data privacy regulations (GDPR, CCPA), and cross-border payment regulations. Focus on European and US markets.', '2025-10-10', '2025-12-24', '{Europe,"North America"}', NULL, 12, 22, NULL, 0, 0, 2, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:52:13.503055-05');
INSERT INTO "expert_network"."campaigns" VALUES ('504b545e-9bef-4694-a176-67feec23ba06', 'demo-user-123', NULL, 'asfa', 'Healthcare', NULL, 'asf', NULL, '2025-11-06', '2025-11-29', '{"Middle East & Africa"}', NULL, 53, 67, NULL, 0, 0, 11, '2025-11-04 19:07:43.920421-05', '2025-11-04 19:07:43.920421-05');

-- ----------------------------
-- Table structure for expert_screening_responses
-- ----------------------------
DROP TABLE IF EXISTS "expert_network"."expert_screening_responses";
CREATE TABLE "expert_network"."expert_screening_responses" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "expert_id" uuid NOT NULL,
  "screening_question_id" uuid NOT NULL,
  "response_text" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of expert_screening_responses
-- ----------------------------
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('24e58288-e6cf-4461-9e12-491e86f403d1', 'e04b135e-4ac5-4252-8634-70af5972ac13', 'fd986082-aaef-4bf5-9bab-2ba3025d017a', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('fff61c23-5129-4afd-b80a-d7fc6828b4c6', 'e04b135e-4ac5-4252-8634-70af5972ac13', '13fcc449-e5cd-44cd-9f8f-302c1ae423d3', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('f025b3dc-5174-4fd1-8547-ed7c40873c6b', '899cba46-296c-45a4-963b-d5b7cafc683b', 'fd986082-aaef-4bf5-9bab-2ba3025d017a', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('d8c6078a-e205-4319-a040-b73cc72b3d7e', '899cba46-296c-45a4-963b-d5b7cafc683b', '13fcc449-e5cd-44cd-9f8f-302c1ae423d3', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('6f2d6149-fe98-4436-9792-60a7ba9312c6', '477dd26a-a28a-42a1-9aae-dde489bd01d8', 'fd986082-aaef-4bf5-9bab-2ba3025d017a', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('371f9a4b-84e0-43fd-9c4e-b3be7554de29', '477dd26a-a28a-42a1-9aae-dde489bd01d8', '13fcc449-e5cd-44cd-9f8f-302c1ae423d3', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('ec044723-a2fa-49b2-a3bc-5cc3b76ab192', '934f8452-2bb0-4adb-b2a0-05d516d07829', '4fb017b8-1448-439d-abe8-2d3e56957c55', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('99c15e8e-6dc5-410f-a284-ed477a4708d0', '934f8452-2bb0-4adb-b2a0-05d516d07829', '428bee3f-7191-493d-95d7-1811932723e6', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('e9c9244d-f6cb-48d9-8b5c-d7ec081547ce', 'd8631458-cde4-4c7a-9c4f-ed172455f6de', '4fb017b8-1448-439d-abe8-2d3e56957c55', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('11c5223a-cde0-4e76-aece-d6f7d3f90e49', 'd8631458-cde4-4c7a-9c4f-ed172455f6de', '428bee3f-7191-493d-95d7-1811932723e6', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('4bbeb5ec-1a81-4886-a3f8-8f95db894606', 'fb2ff16b-eb55-4fe9-a8b0-4f218c8b6e9f', '4fb017b8-1448-439d-abe8-2d3e56957c55', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('c9885faf-5119-47fc-a16e-a3ead69b5ce8', 'fb2ff16b-eb55-4fe9-a8b0-4f218c8b6e9f', '428bee3f-7191-493d-95d7-1811932723e6', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('e1a38c7c-2b14-4864-b3ea-2aa106ceac92', '62b2dae6-b4f3-4cd4-a270-007af8806fce', '7251c111-0e3f-4fdf-ad3e-ae076c7d50f1', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('fc3747a3-362d-4be1-bd06-d16cb9f63534', '62b2dae6-b4f3-4cd4-a270-007af8806fce', '7ee8ab43-74da-467a-aa0a-1693be426e23', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('eb94f8f9-973a-4a51-9ce2-96bd80f574a6', '2d1258bb-2e49-4203-9388-681f364dff7b', '7251c111-0e3f-4fdf-ad3e-ae076c7d50f1', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('dd9a8f85-87b2-470f-9bd8-9d105c4df735', '2d1258bb-2e49-4203-9388-681f364dff7b', '7ee8ab43-74da-467a-aa0a-1693be426e23', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('d94719a9-ce6a-49d5-b556-74ac64276afb', 'd547fc60-dc35-485f-ac40-f55e9661a49d', '7251c111-0e3f-4fdf-ad3e-ae076c7d50f1', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('f5527257-f593-4e24-b8e5-cf2cafe54bb8', 'd547fc60-dc35-485f-ac40-f55e9661a49d', '7ee8ab43-74da-467a-aa0a-1693be426e23', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('2f308b24-10f0-409e-b4d8-98393bcd1aa0', 'dfa933f7-1ab6-4090-8510-8f2f1c3a2258', '0d825daf-81a3-4e19-9226-306f78d423ed', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('ceac00ca-2080-4233-98aa-7b376097d60d', 'dfa933f7-1ab6-4090-8510-8f2f1c3a2258', '6ecab3e7-5dba-4cbd-b7a7-2f526e67a585', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('f1257994-231d-4baf-bea4-743734383b34', '12d76b73-a11c-499d-b501-ded547d84065', '0d825daf-81a3-4e19-9226-306f78d423ed', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('24af74e2-7090-4093-a0a3-0dcc4aa3e194', '12d76b73-a11c-499d-b501-ded547d84065', '6ecab3e7-5dba-4cbd-b7a7-2f526e67a585', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('3c73bf17-b14a-47fe-89be-5477ec9496dc', 'c635a77a-4e3e-408a-93f3-f3f27921b859', '0d825daf-81a3-4e19-9226-306f78d423ed', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('96887da8-2fec-4844-8c54-1830c36cbc2c', 'c635a77a-4e3e-408a-93f3-f3f27921b859', '6ecab3e7-5dba-4cbd-b7a7-2f526e67a585', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('7ec5e0f1-ae8a-4239-9c07-e11d08f18175', 'e327bc97-dda5-4f88-a442-8891f4634c4a', 'bfbcf18a-9cf1-49f1-a828-87e7db5c66ee', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('c747505b-28ae-4269-8f64-bb49073e1bd2', 'e327bc97-dda5-4f88-a442-8891f4634c4a', 'd7e6b395-bd2a-4b80-a912-8da3529d48a4', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('3b91e2e9-8d3f-4db2-979a-69a9ea1732a7', '46b78a83-8e49-4c94-90b2-92fdad396e78', 'bfbcf18a-9cf1-49f1-a828-87e7db5c66ee', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('f97ce7a7-6ef7-4736-b161-1c018978d4c6', '46b78a83-8e49-4c94-90b2-92fdad396e78', 'd7e6b395-bd2a-4b80-a912-8da3529d48a4', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('9c681460-1fa5-47a3-863c-ac0db5780579', 'd3a36911-78a7-4da5-9e3f-355a7f438943', 'bfbcf18a-9cf1-49f1-a828-87e7db5c66ee', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('74ebbfbb-f11a-4d44-a9b2-1cea3f5198ce', 'd3a36911-78a7-4da5-9e3f-355a7f438943', 'd7e6b395-bd2a-4b80-a912-8da3529d48a4', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('09df1a93-25f3-460e-91c3-cc672405c729', '051c3746-15de-405d-a8a3-238952be9018', 'f43d180f-325c-4925-b683-e6102e5361a3', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('c050614b-c9e6-4c36-a6bf-ef857450b318', '051c3746-15de-405d-a8a3-238952be9018', 'f867b627-8da3-4fb0-a5cd-adeeff58a680', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('e18443a6-4e7d-4b6e-9bf7-40b6c8d76135', '8a5163eb-11a6-4086-9932-26a1d40f4afb', 'f43d180f-325c-4925-b683-e6102e5361a3', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('d7aa2246-3a8d-4b43-920a-9c2f1700aa33', '8a5163eb-11a6-4086-9932-26a1d40f4afb', 'f867b627-8da3-4fb0-a5cd-adeeff58a680', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('09158596-6011-423d-b31f-db6a827b4307', '108fb291-3383-4039-a7c8-b395c7fd18dd', 'f43d180f-325c-4925-b683-e6102e5361a3', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('b616e324-985e-41a1-98f5-a43b9933a539', '108fb291-3383-4039-a7c8-b395c7fd18dd', 'f867b627-8da3-4fb0-a5cd-adeeff58a680', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('0b7d4f14-bc11-4f9d-80d8-6ad8e1046264', '09f011d1-e002-4eb8-9017-89c39380d8d6', 'ee6626b2-77aa-46bc-b961-b6388b3c2ed7', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('b0b6e147-c7b6-46d6-84f7-8af178fc2ed0', '09f011d1-e002-4eb8-9017-89c39380d8d6', 'd9ac161a-988b-4fa3-a8e6-3feaca954800', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('b59dcf87-af55-412e-bbc7-bcebc7179ec0', '5d53074d-a04d-4e85-a88a-6d916f5d7bcd', 'ee6626b2-77aa-46bc-b961-b6388b3c2ed7', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('2557fb0d-fc8c-4860-a711-04d6fc111f08', '5d53074d-a04d-4e85-a88a-6d916f5d7bcd', 'd9ac161a-988b-4fa3-a8e6-3feaca954800', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('5c9310b0-65d1-4442-b4a2-a08c08f0ac7b', '449a1cbf-379e-47fa-9302-b5a724958d6b', 'ee6626b2-77aa-46bc-b961-b6388b3c2ed7', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('37893948-f0c1-4715-8a5f-b753a3b9a6c5', '449a1cbf-379e-47fa-9302-b5a724958d6b', 'd9ac161a-988b-4fa3-a8e6-3feaca954800', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('fe4b9769-2f64-475d-9e36-be7964a5a533', '6513d738-540a-4981-88ea-f6533b673c90', 'd4272b14-3656-4fa6-92e2-509c128f1c8d', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('1fb67692-8089-415d-b3f0-6bec18b2a073', '6513d738-540a-4981-88ea-f6533b673c90', '6390d450-099c-47c8-8137-610f7f40e3fe', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('a0557634-b317-4f7b-82e9-f841d91ed9e5', '3ae16b15-a508-4b15-9097-906a166649e0', 'd4272b14-3656-4fa6-92e2-509c128f1c8d', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('b9f2314b-75f9-4a66-b86c-e639669121cb', '3ae16b15-a508-4b15-9097-906a166649e0', '6390d450-099c-47c8-8137-610f7f40e3fe', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('cc2e842c-e4f4-4459-93a8-876774884592', 'b277c0ee-d4d8-439d-b2ac-a2577ce4de64', 'd4272b14-3656-4fa6-92e2-509c128f1c8d', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('4ba73e99-b40b-4af3-a244-cd142fd88e45', 'b277c0ee-d4d8-439d-b2ac-a2577ce4de64', '6390d450-099c-47c8-8137-610f7f40e3fe', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('6e5fa5f3-f6e4-4a00-a749-14d7c05d5f9c', '8b2b51dd-be6a-4773-bcf8-2d29a2b1dc04', 'b24ca7f2-c52b-4c18-90ba-a3a755da22ed', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('75c9a428-a33a-4633-ac3b-b212ad426606', '8b2b51dd-be6a-4773-bcf8-2d29a2b1dc04', '0114c826-4c3d-409c-a383-3b74f8dc2b45', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('992bd515-8887-48b4-8e14-dd313149681e', 'e72dd2d6-e729-44fd-9a5a-6d7371e932d5', 'b24ca7f2-c52b-4c18-90ba-a3a755da22ed', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('ce5da046-2188-4fef-932e-3602c4907045', 'e72dd2d6-e729-44fd-9a5a-6d7371e932d5', '0114c826-4c3d-409c-a383-3b74f8dc2b45', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('a230382f-b6c1-450f-beec-e4d0e5ca3d65', '409231cc-851e-4808-af94-f8af46549dc0', 'ac3c38a8-2f8a-40e9-aba7-a9a544f6caae', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('605a9c23-e571-4b39-b3b0-8b3afbc6e894', '409231cc-851e-4808-af94-f8af46549dc0', '813e6cda-8642-41f6-8bf3-0248cb971ed9', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('a8e0bc27-c7d1-40f7-b20c-7c984432cc73', '7f7ab869-4bb7-450f-85ad-2331fc5caa58', 'ac3c38a8-2f8a-40e9-aba7-a9a544f6caae', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('478a0750-2bd7-422b-bdcd-dc8e19655752', '7f7ab869-4bb7-450f-85ad-2331fc5caa58', '813e6cda-8642-41f6-8bf3-0248cb971ed9', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('51031953-9a34-4744-b8d2-a0e5953f9b01', '8978eff9-a937-4c8a-ada7-c0db2587456c', 'ac3c38a8-2f8a-40e9-aba7-a9a544f6caae', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."expert_screening_responses" VALUES ('adb82762-eeb7-46f2-a4ce-c0ca38b5484c', '8978eff9-a937-4c8a-ada7-c0db2587456c', '813e6cda-8642-41f6-8bf3-0248cb971ed9', 'Comprehensive response based on extensive experience in the field. I have worked on multiple projects involving this topic and can provide detailed insights based on real-world implementation experience.', '2025-11-04 18:04:56.028923-05');

-- ----------------------------
-- Table structure for experts
-- ----------------------------
DROP TABLE IF EXISTS "expert_network"."experts";
CREATE TABLE "expert_network"."experts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "campaign_id" uuid NOT NULL,
  "vendor_platform_id" uuid NOT NULL,
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "title" text COLLATE "pg_catalog"."default" NOT NULL,
  "company" text COLLATE "pg_catalog"."default",
  "avatar_url" text COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "work_history" text COLLATE "pg_catalog"."default",
  "skills" text[] COLLATE "pg_catalog"."default" DEFAULT '{}'::text[],
  "rating" numeric(2,1),
  "ai_fit_score" int4,
  "status" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'proposed'::text,
  "is_new" bool NOT NULL DEFAULT true,
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "updated_at" timestamptz(6) NOT NULL DEFAULT now(),
  "reviewed_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of experts
-- ----------------------------
INSERT INTO "expert_network"."experts" VALUES ('899cba46-296c-45a4-963b-d5b7cafc683b', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b', 'Dr. Sarah Chen', 'Chief Medical Information Officer', 'Memorial Hospital System', '/images/experts/Andrew Collins.png', 'CMIO with 12 years of experience implementing clinical AI systems across major hospital networks. Led Epic EHR integration with AI-powered clinical decision support tools.', 'Memorial Hospital System (CMIO, 2018-present): Led AI initiatives including radiology AI for chest X-ray analysis, reducing diagnostic time by 40%. Previously: Johns Hopkins (Clinical Informatics Director, 2016-2018), Mayo Clinic (Physician Informatics, 2012-2016).', '{"Clinical AI","EHR Integration","Healthcare IT","Clinical Decision Support","Epic Systems"}', 4.8, 9, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('477dd26a-a28a-42a1-9aae-dde489bd01d8', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'a1b2c3d4-e5f6-4789-a123-567890abcdef', 'Michael Rodriguez', 'VP of Clinical Operations', 'Mayo Clinic', '/images/experts/Benjamin Carter.png', 'Healthcare executive specializing in AI-driven clinical operations optimization. Expert in process improvement and digital health transformation.', 'Mayo Clinic (VP Clinical Operations, 2019-present): Implemented AI-powered scheduling and resource optimization, improving patient throughput by 25%. Previously: Cleveland Clinic (Director of Operations, 2015-2019), Mass General (Operations Manager, 2010-2015).', '{"Clinical Operations","Process Improvement","Healthcare Analytics","Digital Transformation"}', 4.7, 8, 'reviewed', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('e04b135e-4ac5-4252-8634-70af5972ac13', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'b2c3d4e5-f6a7-4801-b345-678901bcdefb', 'Dr. Emily Watson', 'Director of Digital Health', 'Cleveland Clinic', '/images/experts/Christopher Shaw.png', 'Leading expert in digital health initiatives and telemedicine implementation. Specializes in AI-powered patient engagement platforms.', 'Cleveland Clinic (Director Digital Health, 2020-present): Launched AI chatbot for patient triage, handling 50K+ patient interactions monthly. Previously: Stanford Health (Digital Health Manager, 2017-2020), Kaiser Permanente (Telemedicine Coordinator, 2014-2017).', '{"Digital Health",Telemedicine,"Patient Engagement","AI Chatbots","Healthcare Innovation"}', 4.9, 9, 'approved', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('934f8452-2bb0-4adb-b2a0-05d516d07829', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'c3d4e5f6-a7b8-4012-c456-789012cdefab', 'James Park', 'Senior Data Scientist', 'Johns Hopkins Medical Imaging', '/images/experts/Daniel Reed.png', 'Data science expert specializing in medical imaging AI. Developed deep learning models for radiology and pathology image analysis.', 'Johns Hopkins (Senior Data Scientist, 2018-present): Developed FDA-cleared AI model for lung nodule detection in CT scans. Previously: MIT CSAIL (Research Scientist, 2015-2018), Google Health (ML Engineer, 2013-2015).', '{"Medical Imaging AI","Deep Learning","Computer Vision","Radiology AI",Python,TensorFlow}', 4.6, 10, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('fb2ff16b-eb55-4fe9-a8b0-4f218c8b6e9f', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'd4e5f6a7-b8c9-4123-d567-890123defabc', 'Dr. Lisa Anderson', 'Chief of Radiology', 'Massachusetts General Hospital', '/images/experts/Daniel.png', 'Radiologist with 15 years of experience using AI tools for diagnostic imaging. Expert in FDA approval process for medical imaging AI.', 'Mass General (Chief of Radiology, 2017-present): Implemented AI-powered mammography screening, improving early detection rates by 30%. Previously: Brigham and Women''s (Staff Radiologist, 2010-2017), Harvard Medical School (Residency, 2005-2010).', '{Radiology,"Medical Imaging","AI Diagnostics","FDA Regulation",Mammography}', 4.8, 9, 'reviewed', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('62b2dae6-b4f3-4cd4-a270-007af8806fce', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'e5f6a7b8-c9d0-4234-e678-901234efabcd', 'Robert Kim', 'VP of Compliance', 'JP Morgan Chase', '/images/experts/Ethan Clarke.png', 'Banking compliance executive with expertise in digital banking regulations, KYC/AML, and cross-border payment compliance.', 'JP Morgan Chase (VP Compliance, 2019-present): Led digital banking compliance for $50B+ in deposits. Previously: Bank of America (Senior Compliance Manager, 2015-2019), Federal Reserve (Regulatory Analyst, 2012-2015).', '{"Banking Compliance",KYC/AML,"Regulatory Affairs","Digital Banking","Cross-Border Payments"}', 4.7, 8, 'approved', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('d547fc60-dc35-485f-ac40-f55e9661a49d', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'f6a7b8c9-d0e1-4345-f789-012345fabcde', 'David Thompson', 'Chief Regulatory Officer', 'Goldman Sachs', '/images/experts/Henry Wallace.png', 'Regulatory expert specializing in FinTech compliance and digital banking regulations across US and European markets.', 'Goldman Sachs (CRO, 2020-present): Oversee regulatory compliance for Marcus digital banking platform. Previously: Credit Suisse (Head of Regulatory Affairs, 2016-2020), SEC (Senior Attorney, 2011-2016).', '{"Regulatory Compliance",FinTech,GDPR,"Financial Regulations","Banking Law"}', 4.6, 8, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('c635a77a-4e3e-408a-93f3-f3f27921b859', '32f3acce-0f98-440d-a295-c48c64acfc46', 'a7b8c9d0-e1f2-4456-a890-123456abcdef', 'Jennifer Lee', 'Cryptocurrency Regulatory Expert', 'Coinbase', '/images/experts/James Whitman.PNG', 'Leading expert on cryptocurrency regulations, SEC compliance, and DeFi regulatory frameworks.', 'Coinbase (Regulatory Expert, 2021-present): Advised on SEC registration and compliance framework. Previously: CFTC (Cryptocurrency Specialist, 2018-2021), SEC (Attorney-Advisor, 2015-2018).', '{Cryptocurrency,"Blockchain Regulation","SEC Compliance",DeFi,"Regulatory Strategy"}', 4.8, 9, 'reviewed', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('dfa933f7-1ab6-4090-8510-8f2f1c3a2258', '32f3acce-0f98-440d-a295-c48c64acfc46', 'b8c9d0e1-f2a3-4567-b901-234567bcdefb', 'Christopher Brown', 'Head of Legal', 'Binance US', '/images/experts/Kevin_Smith.png', 'Legal expert specializing in cryptocurrency exchanges, token regulations, and cross-border crypto compliance.', 'Binance US (Head of Legal, 2020-present): Managed regulatory compliance for major crypto exchange. Previously: Kraken (Legal Counsel, 2017-2020), Ripple (Regulatory Affairs, 2015-2017).', '{"Crypto Regulation","Exchange Compliance","Token Securities","Cross-Border Compliance"}', 4.7, 8, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('e327bc97-dda5-4f88-a442-8891f4634c4a', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'c9d0e1f2-a3b4-4678-c012-345678cdefab', 'Lucas Turner', 'VP of Pricing Strategy', 'Salesforce', '/images/experts/Lucas Turner.png', 'Pricing strategy executive with 10 years of experience in enterprise SaaS pricing, value-based pricing, and competitive positioning.', 'Salesforce (VP Pricing Strategy, 2019-present): Led pricing strategy for $20B+ SaaS portfolio. Previously: Microsoft (Senior Pricing Manager, 2016-2019), Oracle (Pricing Analyst, 2013-2016).', '{"SaaS Pricing","Value-Based Pricing","Pricing Strategy","Enterprise Sales","Competitive Analysis"}', 4.9, 9, 'approved', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('46b78a83-8e49-4c94-90b2-92fdad396e78', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'd0e1f2a3-b4c5-4789-d123-456789defabc', 'Matthew Lawson', 'Chief Revenue Officer', 'HubSpot', '/images/experts/Matthew Lawson.png', 'Revenue leader with expertise in usage-based pricing, freemium models, and enterprise sales motions for SaaS companies.', 'HubSpot (CRO, 2020-present): Implemented usage-based pricing model, increasing revenue by 40%. Previously: Atlassian (VP Sales, 2017-2020), Dropbox (Sales Director, 2014-2017).', '{"Usage-Based Pricing","Freemium Models","Revenue Operations","Sales Strategy"}', 4.8, 9, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('8a5163eb-11a6-4086-9932-26a1d40f4afb', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', 'e1f2a3b4-c5d6-4890-e234-567890efabcd', 'Nathaniel Brooks', 'VP of Enterprise Sales', 'ServiceNow', '/images/experts/Nathaniel Brooks.png', 'Enterprise sales executive with track record of building $100M+ sales organizations. Expert in account-based marketing and customer success.', 'ServiceNow (VP Enterprise Sales, 2018-present): Built enterprise sales team generating $500M+ ARR. Previously: Workday (Sales Director, 2015-2018), Oracle (Enterprise Account Executive, 2010-2015).', '{"Enterprise Sales","Account-Based Marketing","Customer Success","Sales Enablement","B2B SaaS"}', 4.7, 8, 'reviewed', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('051c3746-15de-405d-a8a3-238952be9018', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', 'f2a3b4c5-d6e7-4901-f345-678901fabcde', 'Oliver Grant', 'Chief Customer Officer', 'Slack', '/images/experts/Oliver Grant.png', 'Customer success leader specializing in enterprise customer expansion, retention strategies, and customer-led growth.', 'Slack (CCO, 2019-present): Increased enterprise customer retention from 85% to 95%. Previously: Zendesk (VP Customer Success, 2016-2019), Salesforce (Customer Success Manager, 2013-2016).', '{"Customer Success","Customer Retention","Expansion Revenue","Customer-Led Growth"}', 4.8, 9, 'approved', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('4704755a-b8c5-47fd-ae79-1f7774f81a51', '56173be4-49a7-4266-9eac-07114c2007a8', 'a3b4c5d6-e7f8-4012-a456-789012abcdef', 'Samuel Hayes', 'VP of Supply Chain', 'Amazon', '/images/experts/Samuel Hayes.png', 'Supply chain executive with expertise in global logistics, supplier diversification, and supply chain technology.', 'Amazon (VP Supply Chain, 2017-present): Managed global supply chain for $400B+ e-commerce operations. Previously: Walmart (Supply Chain Director, 2014-2017), Procter & Gamble (Supply Chain Manager, 2010-2014).', '{"Supply Chain Management","Global Logistics","Supplier Diversification","Supply Chain Technology"}', 4.9, 9, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('e64d4fbf-1609-4259-b7d6-b7bf2bba7634', '56173be4-49a7-4266-9eac-07114c2007a8', 'b4c5d6e7-f8a9-4123-b567-890123bcdefb', 'William Foster', 'Chief Operating Officer', 'FedEx', '/images/experts/William Foster.png', 'Logistics executive with 20 years of experience in transportation, warehousing, and last-mile delivery optimization.', 'FedEx (COO, 2019-present): Oversee $90B+ global logistics network. Previously: UPS (VP Operations, 2015-2019), DHL (Operations Director, 2010-2015).', '{Logistics,Transportation,Warehousing,"Last-Mile Delivery","Supply Chain Optimization"}', 4.8, 8, 'reviewed', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('09f011d1-e002-4eb8-9017-89c39380d8d6', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'c5d6e7f8-a9b0-4234-c678-901234cdefab', 'Andrew Collins', 'CTO', 'Blue Yonder', '/images/experts/Andrew Collins.png', 'Technology executive specializing in supply chain software platforms, WMS, TMS, and demand forecasting systems.', 'Blue Yonder (CTO, 2020-present): Led development of AI-powered supply chain platform serving Fortune 500 companies. Previously: Manhattan Associates (VP Engineering, 2017-2020), Oracle (Supply Chain Product Manager, 2014-2017).', '{"Supply Chain Software",WMS,TMS,"Demand Forecasting",AI/ML,"Enterprise Software"}', 4.7, 9, 'approved', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('449a1cbf-379e-47fa-9302-b5a724958d6b', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'd6e7f8a9-b0c1-4345-d789-012345defabc', 'Benjamin Carter', 'VP of Product', 'Flexport', '/images/experts/Benjamin Carter.png', 'Product leader with expertise in supply chain visibility platforms, freight management, and logistics technology.', 'Flexport (VP Product, 2019-present): Built supply chain visibility platform processing $10B+ in freight. Previously: Convoy (Product Director, 2017-2019), Uber Freight (Product Manager, 2015-2017).', '{"Supply Chain Visibility","Freight Management","Logistics Technology","Product Management"}', 4.6, 8, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('3ae16b15-a508-4b15-9097-906a166649e0', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'e7f8a9b0-c1d2-4456-e890-123456efabcd', 'Ethan Clarke', 'VP of Solar Development', 'Sunrun', '/images/experts/Christopher Shaw.png', 'Solar energy executive with expertise in residential and commercial solar installation, financing, and market dynamics.', 'Sunrun (VP Solar Development, 2018-present): Led residential solar installations across 22 states, 500K+ customers. Previously: SolarCity (Development Director, 2015-2018), First Solar (Business Development, 2012-2015).', '{"Solar Energy","Residential Solar","Commercial Solar","Solar Installation","Renewable Energy"}', 4.8, 9, 'reviewed', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('6513d738-540a-4981-88ea-f6533b673c90', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b', 'Henry Wallace', 'Chief Technology Officer', 'First Solar', '/images/experts/Daniel Reed.png', 'Solar technology expert specializing in panel technology, efficiency improvements, and manufacturing economics.', 'First Solar (CTO, 2019-present): Led development of next-gen thin-film solar panels with 22% efficiency. Previously: SunPower (VP R&D, 2016-2019), NREL (Senior Research Scientist, 2012-2016).', '{"Solar Panel Technology","Thin-Film Solar",Photovoltaics,Manufacturing,R&D}', 4.9, 10, 'approved', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('8b2b51dd-be6a-4773-bcf8-2d29a2b1dc04', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'a1b2c3d4-e5f6-4789-a123-567890abcdef', 'Jacob Martinez', 'VP of Energy Storage', 'Tesla Energy', '/images/experts/Daniel.png', 'Energy storage executive with expertise in grid-scale battery systems, lithium-ion technology, and energy storage economics.', 'Tesla Energy (VP Energy Storage, 2020-present): Deployed 3GWh+ of grid-scale battery storage globally. Previously: AES Energy Storage (Director, 2017-2020), GE Energy Storage (Product Manager, 2014-2017).', '{"Energy Storage","Battery Technology","Grid-Scale Storage",Lithium-Ion,"Renewable Energy Integration"}', 4.8, 9, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('e72dd2d6-e729-44fd-9a5a-6d7371e932d5', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'b2c3d4e5-f6a7-4801-b345-678901bcdefb', 'Kevin Park', 'Chief Scientist', 'Fluence Energy', '/images/experts/Ethan Clarke.png', 'Energy storage scientist specializing in flow batteries, advanced battery chemistries, and grid integration.', 'Fluence Energy (Chief Scientist, 2019-present): Developed flow battery systems for long-duration energy storage. Previously: Form Energy (Senior Scientist, 2016-2019), MIT (Research Scientist, 2012-2016).', '{"Flow Batteries","Advanced Battery Chemistry","Long-Duration Storage","Grid Integration","Energy Research"}', 4.7, 9, 'reviewed', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('409231cc-851e-4808-af94-f8af46549dc0', 'bead487a-b8b1-420f-8bca-ee4983b37559', 'c3d4e5f6-a7b8-4012-c456-789012cdefab', 'Daniel Reed', 'Chief Information Security Officer', 'Microsoft', '/images/experts/Henry Wallace.png', 'Cybersecurity executive with expertise in zero trust architecture, identity management, and enterprise security.', 'Microsoft (CISO, 2021-present): Implemented zero trust architecture across 200K+ employees globally. Previously: Google (Security Director, 2018-2021), Palo Alto Networks (Security Architect, 2015-2018).', '{"Zero Trust",Cybersecurity,"Identity Management","Enterprise Security","Cloud Security"}', 4.9, 10, 'approved', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('8978eff9-a937-4c8a-ada7-c0db2587456c', 'bead487a-b8b1-420f-8bca-ee4983b37559', 'd4e5f6a7-b8c9-4123-d567-890123defabc', 'James Whitman', 'VP of Security Architecture', 'CrowdStrike', '/images/experts/James Whitman.PNG', 'Security architect specializing in zero trust implementation, endpoint security, and threat detection.', 'CrowdStrike (VP Security Architecture, 2019-present): Designed zero trust security architecture for enterprise customers. Previously: FireEye (Security Architect, 2016-2019), Mandiant (Security Consultant, 2013-2016).', '{"Zero Trust Architecture","Endpoint Security","Threat Detection","Security Architecture","Incident Response"}', 4.8, 9, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('1d902814-7eb7-4d20-aa14-15c641af1773', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'e5f6a7b8-c9d0-4234-e678-901234efabcd', 'Dr. Maria Garcia', 'Chief AI Officer', 'Duke Health', '/images/experts/Kevin_Smith.png', 'AI research director specializing in clinical decision support systems and medical AI applications.', 'Duke Health (Chief AI Officer, 2020-present): Led development of AI-powered clinical decision support tools. Previously: IBM Watson Health (Research Director, 2017-2020), Google Health (Research Scientist, 2014-2017).', '{"Clinical AI","Decision Support","Medical AI",Research,"Deep Learning"}', 4.9, 10, 'reviewed', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('d8631458-cde4-4c7a-9c4f-ed172455f6de', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'f6a7b8c9-d0e1-4345-f789-012345fabcde', 'Dr. John Kim', 'Radiology AI Specialist', 'Stanford Health', '/images/experts/Lucas Turner.png', 'Radiologist and AI researcher specializing in deep learning for medical image analysis.', 'Stanford Health (AI Specialist, 2019-present): Developed FDA-cleared AI tools for radiology. Previously: Stanford AI Lab (Research Fellow, 2016-2019), MD Anderson (Resident, 2013-2016).', '{"Radiology AI","Deep Learning","Medical Imaging","Computer Vision","AI Research"}', 4.7, 9, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('2d1258bb-2e49-4203-9388-681f364dff7b', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'a7b8c9d0-e1f2-4456-a890-123456abcdef', 'Patricia Williams', 'Regulatory Compliance Expert', 'Citibank', '/images/experts/Matthew Lawson.png', 'Banking compliance expert with 15 years of experience in digital banking regulations and KYC/AML.', 'Citibank (Compliance Expert, 2018-present): Led compliance for digital banking platform serving 50M+ customers. Previously: Bank of America (Compliance Manager, 2015-2018), OCC (Examiner, 2010-2015).', '{"Banking Compliance",KYC/AML,"Digital Banking","Regulatory Affairs"}', 4.6, 8, 'approved', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('d3a36911-78a7-4da5-9e3f-355a7f438943', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'b8c9d0e1-f2a3-4567-b901-234567bcdefb', 'Thomas Anderson', 'Pricing Strategy Consultant', 'McKinsey & Company', '/images/experts/Nathaniel Brooks.png', 'Management consultant specializing in SaaS pricing strategy, value-based pricing, and competitive positioning.', 'McKinsey (Partner, 2017-present): Led pricing strategy engagements for Fortune 500 SaaS companies. Previously: BCG (Principal, 2014-2017), Deloitte (Senior Manager, 2010-2014).', '{"Pricing Strategy","Value-Based Pricing","Management Consulting","SaaS Strategy"}', 4.8, 8, 'reviewed', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('fc8fa543-acae-4f1a-83f1-29d3d1cf2bff', '56173be4-49a7-4266-9eac-07114c2007a8', 'c9d0e1f2-a3b4-4678-c012-345678cdefab', 'Ryan Murphy', 'Supply Chain Director', 'Walmart', '/images/experts/Oliver Grant.png', 'Supply chain executive with expertise in global sourcing, supplier management, and logistics optimization.', 'Walmart (Supply Chain Director, 2018-present): Managed $500B+ supply chain operations. Previously: Target (VP Supply Chain, 2015-2018), Procter & Gamble (Supply Chain Manager, 2011-2015).', '{"Supply Chain","Global Sourcing","Supplier Management",Logistics}', 4.7, 8, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('b277c0ee-d4d8-439d-b2ac-a2577ce4de64', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'd0e1f2a3-b4c5-4789-d123-456789defabc', 'Rachel Green', 'Solar Market Analyst', 'Wood Mackenzie', '/images/experts/Samuel Hayes.png', 'Energy market analyst specializing in solar market dynamics, policy impacts, and installation economics.', 'Wood Mackenzie (Senior Analyst, 2019-present): Published 50+ reports on solar market trends. Previously: GTM Research (Analyst, 2016-2019), NREL (Research Analyst, 2014-2016).', '{"Solar Market Analysis","Energy Markets","Policy Analysis","Market Research"}', 4.6, 8, 'reviewed', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('7f7ab869-4bb7-450f-85ad-2331fc5caa58', 'bead487a-b8b1-420f-8bca-ee4983b37559', 'e1f2a3b4-c5d6-4890-e234-567890efabcd', 'Alex Johnson', 'Zero Trust Architect', 'Zscaler', '/images/experts/William Foster.png', 'Security architect specializing in zero trust network architecture and secure access service edge (SASE).', 'Zscaler (Principal Architect, 2020-present): Designed zero trust architectures for enterprise customers. Previously: Cloudflare (Security Architect, 2018-2020), Akamai (Security Engineer, 2015-2018).', '{"Zero Trust",SASE,"Network Security","Cloud Security","Security Architecture"}', 4.8, 9, 'approved', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('12d76b73-a11c-499d-b501-ded547d84065', '32f3acce-0f98-440d-a295-c48c64acfc46', 'f2a3b4c5-d6e7-4901-f345-678901fabcde', 'Nicole Brown', 'Crypto Regulatory Attorney', 'Andreessen Horowitz', '/images/experts/1.png', 'Cryptocurrency regulatory attorney with expertise in SEC compliance, token regulations, and DeFi legal frameworks.', 'Andreessen Horowitz (Regulatory Attorney, 2021-present): Advised crypto portfolio companies on regulatory compliance. Previously: SEC (Attorney-Advisor, 2018-2021), Coinbase (Legal Counsel, 2016-2018).', '{"Crypto Regulation","SEC Compliance","Token Securities",DeFi,"Regulatory Law"}', 4.7, 8, 'proposed', 't', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('108fb291-3383-4039-a7c8-b395c7fd18dd', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', 'a3b4c5d6-e7f8-4012-a456-789012abcdef', 'Mark Davis', 'Enterprise Sales Leader', 'Snowflake', '/images/experts/2.png', 'Enterprise sales executive with track record of building high-performing sales teams for SaaS companies.', 'Snowflake (Sales Leader, 2020-present): Built enterprise sales team generating $1B+ ARR. Previously: Tableau (Sales Director, 2017-2020), Salesforce (Enterprise AE, 2014-2017).', '{"Enterprise Sales","Sales Leadership","B2B SaaS","Account Management"}', 4.9, 9, 'reviewed', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."experts" VALUES ('5d53074d-a04d-4e85-a88a-6d916f5d7bcd', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'b4c5d6e7-f8a9-4123-b567-890123bcdefb', 'Laura White', 'Supply Chain Technology Expert', 'SAP', '/images/experts/40.png', 'Supply chain technology expert specializing in ERP integration, supply chain planning, and demand forecasting.', 'SAP (Technology Expert, 2019-present): Led supply chain technology implementations for Fortune 500. Previously: Oracle (Product Manager, 2016-2019), JDA Software (Consultant, 2013-2016).', '{"Supply Chain Technology",ERP,"Supply Chain Planning","Demand Forecasting"}', 4.6, 8, 'approved', 'f', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL);

-- ----------------------------
-- Table structure for interviews
-- ----------------------------
DROP TABLE IF EXISTS "expert_network"."interviews";
CREATE TABLE "expert_network"."interviews" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "campaign_id" uuid NOT NULL,
  "expert_id" uuid NOT NULL,
  "scheduled_date" date NOT NULL,
  "scheduled_time" time(6) NOT NULL,
  "duration_minutes" int4 NOT NULL DEFAULT 60,
  "timezone" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'UTC'::text,
  "status" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'scheduled'::text,
  "color_tag" text COLLATE "pg_catalog"."default",
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "updated_at" timestamptz(6) NOT NULL DEFAULT now(),
  "completed_at" timestamptz(6),
  "cancelled_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of interviews
-- ----------------------------
INSERT INTO "expert_network"."interviews" VALUES ('0d31766b-7efc-406c-882d-79ce2faf2b10', '440b5bab-93b9-4f14-a9e7-66419fcde59d', '899cba46-296c-45a4-963b-d5b7cafc683b', '2025-11-07', '14:00:00', 60, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('3d6a161b-4b16-4c33-83a9-e4092fd794ee', '440b5bab-93b9-4f14-a9e7-66419fcde59d', '899cba46-296c-45a4-963b-d5b7cafc683b', '2025-11-08', '16:00:00', 90, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('64e38656-48a1-4a2e-979a-e172bbe3c94d', '440b5bab-93b9-4f14-a9e7-66419fcde59d', '899cba46-296c-45a4-963b-d5b7cafc683b', '2025-11-09', '10:00:00', 120, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('10dc2cd6-b114-4666-90ef-60ac8053ade1', '440b5bab-93b9-4f14-a9e7-66419fcde59d', '477dd26a-a28a-42a1-9aae-dde489bd01d8', '2025-11-09', '09:00:00', 60, 'America/New_York', 'confirmed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('21744fc1-d9b6-4023-9465-a8ce427d11c8', '440b5bab-93b9-4f14-a9e7-66419fcde59d', '477dd26a-a28a-42a1-9aae-dde489bd01d8', '2025-11-10', '11:00:00', 90, 'America/New_York', 'confirmed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('302e0302-2e9d-4205-9f15-12b05e4857e4', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'e04b135e-4ac5-4252-8634-70af5972ac13', '2025-11-11', '12:00:00', 60, 'America/New_York', 'pending', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('0104043e-7f85-4113-b419-d2aac7de5e9f', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'e04b135e-4ac5-4252-8634-70af5972ac13', '2025-11-12', '14:00:00', 90, 'America/New_York', 'pending', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('2a1c0d10-b845-4078-984f-d3e1dc426156', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'e04b135e-4ac5-4252-8634-70af5972ac13', '2025-11-13', '16:00:00', 120, 'America/New_York', 'pending', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('7639d9a5-dd76-4589-b7a1-8e9c7cd5d605', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', '934f8452-2bb0-4adb-b2a0-05d516d07829', '2025-11-13', '15:00:00', 60, 'America/New_York', 'scheduled', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('c8f1e89a-7287-4a61-a1d7-578b10117a18', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', '934f8452-2bb0-4adb-b2a0-05d516d07829', '2025-11-14', '09:00:00', 90, 'America/New_York', 'scheduled', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('1a085ee0-97fb-4b3a-af99-7d33e2a70d2b', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'fb2ff16b-eb55-4fe9-a8b0-4f218c8b6e9f', '2025-11-15', '10:00:00', 60, 'America/New_York', 'completed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('16c13b3f-39bb-471e-b0f8-67826a0d1ef3', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'fb2ff16b-eb55-4fe9-a8b0-4f218c8b6e9f', '2025-11-16', '12:00:00', 90, 'America/New_York', 'completed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('ceb32df6-e010-47b8-8042-b9fbbe7de5c8', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'fb2ff16b-eb55-4fe9-a8b0-4f218c8b6e9f', '2025-11-17', '14:00:00', 120, 'America/New_York', 'completed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('82ca52f1-f2a7-48c9-ad79-324981b77b03', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', '62b2dae6-b4f3-4cd4-a270-007af8806fce', '2025-11-17', '13:00:00', 60, 'America/New_York', 'scheduled', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('32b84e30-81ed-4452-920c-caffff667bc6', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', '62b2dae6-b4f3-4cd4-a270-007af8806fce', '2025-11-18', '15:00:00', 90, 'America/New_York', 'scheduled', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('49fdb52b-a8ba-417b-b842-ec0a1dd85fe9', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'd547fc60-dc35-485f-ac40-f55e9661a49d', '2025-11-19', '16:00:00', 60, 'America/New_York', 'confirmed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('d4702256-3c98-4e8f-bf3b-c5ea384c85cb', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'd547fc60-dc35-485f-ac40-f55e9661a49d', '2025-11-20', '10:00:00', 90, 'America/New_York', 'confirmed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('4992e4ba-af4b-459d-ac50-6f6e2b05f220', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', 'd547fc60-dc35-485f-ac40-f55e9661a49d', '2025-11-21', '12:00:00', 120, 'America/New_York', 'confirmed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('e82ad2fd-e435-4be1-aa73-ae44c090485a', '32f3acce-0f98-440d-a295-c48c64acfc46', 'c635a77a-4e3e-408a-93f3-f3f27921b859', '2025-11-21', '11:00:00', 60, 'America/New_York', 'pending', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('0d6eddec-c24a-49da-a3f9-f8a938f15066', '32f3acce-0f98-440d-a295-c48c64acfc46', 'c635a77a-4e3e-408a-93f3-f3f27921b859', '2025-11-22', '13:00:00', 90, 'America/New_York', 'pending', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('838522c1-28dd-40c5-931a-4afde03ca8b3', '32f3acce-0f98-440d-a295-c48c64acfc46', 'dfa933f7-1ab6-4090-8510-8f2f1c3a2258', '2025-11-23', '14:00:00', 60, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('5a615ad5-a692-4795-b206-e57fb5b18fc0', '32f3acce-0f98-440d-a295-c48c64acfc46', 'dfa933f7-1ab6-4090-8510-8f2f1c3a2258', '2025-11-24', '16:00:00', 90, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('b6963384-2a79-4c5e-8975-24c7576baae6', '32f3acce-0f98-440d-a295-c48c64acfc46', 'dfa933f7-1ab6-4090-8510-8f2f1c3a2258', '2025-11-25', '10:00:00', 120, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('c6e32b9a-c015-4668-bd2e-9375d92b7ee0', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'e327bc97-dda5-4f88-a442-8891f4634c4a', '2025-11-25', '09:00:00', 60, 'America/New_York', 'completed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('0909431e-2e11-47e8-80b0-cfd81b3991a8', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'e327bc97-dda5-4f88-a442-8891f4634c4a', '2025-11-26', '11:00:00', 90, 'America/New_York', 'completed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('fdde6483-7344-4936-a408-99dca75c070d', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', '46b78a83-8e49-4c94-90b2-92fdad396e78', '2025-11-27', '12:00:00', 60, 'America/New_York', 'scheduled', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('c4fec8f2-a376-4f43-ad0b-0f2475a44701', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', '46b78a83-8e49-4c94-90b2-92fdad396e78', '2025-11-28', '14:00:00', 90, 'America/New_York', 'scheduled', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('22b557c0-084f-4b36-a7f0-f996c13d02d6', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', '46b78a83-8e49-4c94-90b2-92fdad396e78', '2025-11-29', '16:00:00', 120, 'America/New_York', 'scheduled', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('ea62083f-dd93-455c-bd49-2e62368b44e0', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', '8a5163eb-11a6-4086-9932-26a1d40f4afb', '2025-11-29', '15:00:00', 60, 'America/New_York', 'confirmed', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('04f0d57f-3b92-44ce-999a-9667dd702fc5', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', '8a5163eb-11a6-4086-9932-26a1d40f4afb', '2025-11-30', '09:00:00', 90, 'America/New_York', 'confirmed', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('4fbb8e88-8b06-4908-b5bb-59e1c4da1f1e', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', '051c3746-15de-405d-a8a3-238952be9018', '2025-12-01', '10:00:00', 60, 'America/New_York', 'pending', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('b76d661c-fb34-470e-8ca9-6cd06f27d603', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', '051c3746-15de-405d-a8a3-238952be9018', '2025-12-02', '12:00:00', 90, 'America/New_York', 'pending', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('0b5083a9-a344-421b-83c2-18f80785a180', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', '051c3746-15de-405d-a8a3-238952be9018', '2025-12-03', '14:00:00', 120, 'America/New_York', 'pending', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('2331dd8c-b7c7-4a36-84eb-e736e1c7ae98', '56173be4-49a7-4266-9eac-07114c2007a8', '4704755a-b8c5-47fd-ae79-1f7774f81a51', '2025-12-03', '13:00:00', 60, 'America/New_York', 'scheduled', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('a54d9a02-c115-45db-a495-0bd9982dd80c', '56173be4-49a7-4266-9eac-07114c2007a8', '4704755a-b8c5-47fd-ae79-1f7774f81a51', '2025-12-04', '15:00:00', 90, 'America/New_York', 'scheduled', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('4ac824bb-e36e-473a-8553-6ad7959cb3fa', '56173be4-49a7-4266-9eac-07114c2007a8', 'e64d4fbf-1609-4259-b7d6-b7bf2bba7634', '2025-12-05', '16:00:00', 60, 'America/New_York', 'completed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('54e722b5-e733-42ca-919f-f4a8806c2748', '56173be4-49a7-4266-9eac-07114c2007a8', 'e64d4fbf-1609-4259-b7d6-b7bf2bba7634', '2025-12-06', '10:00:00', 90, 'America/New_York', 'completed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('0be3aba5-332b-4554-a80e-53c08a4fe117', '56173be4-49a7-4266-9eac-07114c2007a8', 'e64d4fbf-1609-4259-b7d6-b7bf2bba7634', '2025-12-07', '12:00:00', 120, 'America/New_York', 'completed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('4b783afb-7a04-418c-8eac-164481bdf015', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', '09f011d1-e002-4eb8-9017-89c39380d8d6', '2025-12-07', '11:00:00', 60, 'America/New_York', 'scheduled', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('5270c42f-5884-426d-b8a5-6d664b08359e', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', '09f011d1-e002-4eb8-9017-89c39380d8d6', '2025-12-08', '13:00:00', 90, 'America/New_York', 'scheduled', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('62a73d20-8074-4dba-826f-59458bfad5f1', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', '449a1cbf-379e-47fa-9302-b5a724958d6b', '2025-12-09', '14:00:00', 60, 'America/New_York', 'confirmed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('b099dd02-ffff-4c1e-936e-3359d3ecf8cb', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', '449a1cbf-379e-47fa-9302-b5a724958d6b', '2025-12-10', '16:00:00', 90, 'America/New_York', 'confirmed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('646baf07-24d8-4e81-b806-8c11277c0598', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', '449a1cbf-379e-47fa-9302-b5a724958d6b', '2025-12-11', '10:00:00', 120, 'America/New_York', 'confirmed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('666ba254-2072-4c97-ad1e-b1cc05822aa2', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', '3ae16b15-a508-4b15-9097-906a166649e0', '2025-12-11', '09:00:00', 60, 'America/New_York', 'pending', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('f1ce63a7-aef7-4551-a346-3031c5adba2d', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', '3ae16b15-a508-4b15-9097-906a166649e0', '2025-12-12', '11:00:00', 90, 'America/New_York', 'pending', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('470f2518-7c98-4d90-a3b5-f0bc5bf2651f', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', '6513d738-540a-4981-88ea-f6533b673c90', '2025-12-13', '12:00:00', 60, 'America/New_York', 'scheduled', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('cc1436c3-182d-438a-ac83-9e15244ae5ca', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', '6513d738-540a-4981-88ea-f6533b673c90', '2025-12-14', '14:00:00', 90, 'America/New_York', 'scheduled', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('ed11dee7-e85a-4507-b5e8-22431411f15f', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', '6513d738-540a-4981-88ea-f6533b673c90', '2025-12-15', '16:00:00', 120, 'America/New_York', 'scheduled', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('9b7570ec-c784-4073-858f-a69a90f0e8e5', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', '8b2b51dd-be6a-4773-bcf8-2d29a2b1dc04', '2025-12-15', '15:00:00', 60, 'America/New_York', 'completed', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('d8877698-1888-443b-9a5d-3b188b3227b3', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', '8b2b51dd-be6a-4773-bcf8-2d29a2b1dc04', '2025-12-16', '09:00:00', 90, 'America/New_York', 'completed', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('82de1d62-e582-4f47-bfce-3cf4c6e153e8', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'e72dd2d6-e729-44fd-9a5a-6d7371e932d5', '2025-12-17', '10:00:00', 60, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('3f816f29-73ec-47dc-845a-751814af9427', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'e72dd2d6-e729-44fd-9a5a-6d7371e932d5', '2025-12-18', '12:00:00', 90, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('93418840-e2dc-4114-b933-08ec602791d7', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'e72dd2d6-e729-44fd-9a5a-6d7371e932d5', '2025-12-19', '14:00:00', 120, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('00f901c7-56c0-404e-b9ab-9dc58624b507', 'bead487a-b8b1-420f-8bca-ee4983b37559', '409231cc-851e-4808-af94-f8af46549dc0', '2025-12-19', '13:00:00', 60, 'America/New_York', 'confirmed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('1e511c26-1ee8-4104-87ce-20de08fc25bd', 'bead487a-b8b1-420f-8bca-ee4983b37559', '409231cc-851e-4808-af94-f8af46549dc0', '2025-12-20', '15:00:00', 90, 'America/New_York', 'confirmed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('ada9a419-7937-4711-8848-ace876905b28', 'bead487a-b8b1-420f-8bca-ee4983b37559', '8978eff9-a937-4c8a-ada7-c0db2587456c', '2025-12-21', '16:00:00', 60, 'America/New_York', 'pending', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('1def9d95-7d5d-4145-8cc3-5bf751c60f50', 'bead487a-b8b1-420f-8bca-ee4983b37559', '8978eff9-a937-4c8a-ada7-c0db2587456c', '2025-12-22', '10:00:00', 90, 'America/New_York', 'pending', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('5c62ab6b-5c2c-4806-89bc-fffbd3c6a739', 'bead487a-b8b1-420f-8bca-ee4983b37559', '8978eff9-a937-4c8a-ada7-c0db2587456c', '2025-12-23', '12:00:00', 120, 'America/New_York', 'pending', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('46116fa9-d221-4710-af0f-0de5f8c8f849', '440b5bab-93b9-4f14-a9e7-66419fcde59d', '1d902814-7eb7-4d20-aa14-15c641af1773', '2025-12-23', '11:00:00', 60, 'America/New_York', 'scheduled', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('68a267cf-daeb-48e2-bbc7-eb27aefd4b0f', '440b5bab-93b9-4f14-a9e7-66419fcde59d', '1d902814-7eb7-4d20-aa14-15c641af1773', '2025-12-24', '13:00:00', 90, 'America/New_York', 'scheduled', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('45351e2a-8c61-45e7-a46c-88985468c098', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'd8631458-cde4-4c7a-9c4f-ed172455f6de', '2025-12-25', '14:00:00', 60, 'America/New_York', 'completed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('683b9843-33db-4b4e-b662-cdb41c276afc', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'd8631458-cde4-4c7a-9c4f-ed172455f6de', '2025-12-26', '16:00:00', 90, 'America/New_York', 'completed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('68ad262d-da15-4a10-acd5-9eac5464bfe8', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'd8631458-cde4-4c7a-9c4f-ed172455f6de', '2025-12-27', '10:00:00', 120, 'America/New_York', 'completed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('1ef9ce30-9e55-4d17-98cc-360546880622', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', '2d1258bb-2e49-4203-9388-681f364dff7b', '2025-12-27', '09:00:00', 60, 'America/New_York', 'scheduled', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('17f3197c-de5a-4890-a71a-fc35eb084eb5', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', '2d1258bb-2e49-4203-9388-681f364dff7b', '2025-12-28', '11:00:00', 90, 'America/New_York', 'scheduled', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('314b39bc-711f-4f2c-a9ca-b7f95aaf39b3', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'd3a36911-78a7-4da5-9e3f-355a7f438943', '2025-12-29', '12:00:00', 60, 'America/New_York', 'confirmed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('5bf77d60-7e9f-4de4-88dd-2b3a93d585f0', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'd3a36911-78a7-4da5-9e3f-355a7f438943', '2025-12-30', '14:00:00', 90, 'America/New_York', 'confirmed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('7336a572-d190-45a5-886a-75e3d2ee6ba0', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'd3a36911-78a7-4da5-9e3f-355a7f438943', '2025-12-31', '16:00:00', 120, 'America/New_York', 'confirmed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('2f92087a-2e2c-4983-a42b-afb8895e6899', '56173be4-49a7-4266-9eac-07114c2007a8', 'fc8fa543-acae-4f1a-83f1-29d3d1cf2bff', '2025-12-31', '15:00:00', 60, 'America/New_York', 'pending', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('a4c8b857-9a5e-41e8-a9cf-bdb402ecd0c4', '56173be4-49a7-4266-9eac-07114c2007a8', 'fc8fa543-acae-4f1a-83f1-29d3d1cf2bff', '2026-01-01', '09:00:00', 90, 'America/New_York', 'pending', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('f480b73a-43b2-4fab-866b-c34cfa295cfd', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'b277c0ee-d4d8-439d-b2ac-a2577ce4de64', '2026-01-02', '10:00:00', 60, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('bf0acc63-88ac-4ef7-84a2-05af82bc8f38', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'b277c0ee-d4d8-439d-b2ac-a2577ce4de64', '2026-01-03', '12:00:00', 90, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('c6824946-2fcd-4710-a63e-fea750aebe80', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'b277c0ee-d4d8-439d-b2ac-a2577ce4de64', '2026-01-04', '14:00:00', 120, 'America/New_York', 'scheduled', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('140de2b5-220c-4535-bf24-b2059dc52529', 'bead487a-b8b1-420f-8bca-ee4983b37559', '7f7ab869-4bb7-450f-85ad-2331fc5caa58', '2026-01-04', '13:00:00', 60, 'America/New_York', 'completed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('f4525389-43bc-4639-a955-9b7af5d13f27', 'bead487a-b8b1-420f-8bca-ee4983b37559', '7f7ab869-4bb7-450f-85ad-2331fc5caa58', '2026-01-05', '15:00:00', 90, 'America/New_York', 'completed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('73bbc89f-b599-44ef-a343-3fc099e6cf39', '32f3acce-0f98-440d-a295-c48c64acfc46', '12d76b73-a11c-499d-b501-ded547d84065', '2026-01-06', '16:00:00', 60, 'America/New_York', 'scheduled', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('5d589e3a-c812-4966-9093-13bc6315be89', '32f3acce-0f98-440d-a295-c48c64acfc46', '12d76b73-a11c-499d-b501-ded547d84065', '2026-01-07', '10:00:00', 90, 'America/New_York', 'scheduled', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('9c27421d-0a3c-4cd7-89a1-af3c21d1a331', '32f3acce-0f98-440d-a295-c48c64acfc46', '12d76b73-a11c-499d-b501-ded547d84065', '2026-01-08', '12:00:00', 120, 'America/New_York', 'scheduled', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('fcaeae8a-b2fe-41a8-a361-50cca9ca1d0f', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', '108fb291-3383-4039-a7c8-b395c7fd18dd', '2026-01-08', '11:00:00', 60, 'America/New_York', 'confirmed', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('e61b869f-9dea-4b27-89e1-124a4a62b4bb', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', '108fb291-3383-4039-a7c8-b395c7fd18dd', '2026-01-09', '13:00:00', 90, 'America/New_York', 'confirmed', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('2f731c4c-e82e-496d-ad62-5fc1500958e0', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', '5d53074d-a04d-4e85-a88a-6d916f5d7bcd', '2026-01-10', '14:00:00', 60, 'America/New_York', 'pending', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('ca8a159d-966e-4d9a-a6b5-fe10da05b508', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', '5d53074d-a04d-4e85-a88a-6d916f5d7bcd', '2026-01-11', '16:00:00', 90, 'America/New_York', 'pending', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('95dbfffe-a1f9-49bd-be3c-0ba4fc53cb79', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', '5d53074d-a04d-4e85-a88a-6d916f5d7bcd', '2026-01-12', '10:00:00', 120, 'America/New_York', 'pending', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', NULL, NULL);
INSERT INTO "expert_network"."interviews" VALUES ('dc2eef2b-f606-4320-9ee9-6bcba914a8ad', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'e04b135e-4ac5-4252-8634-70af5972ac13', '2025-11-03', '11:00:00', 60, 'America/New_York', 'completed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-11-03 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('826e5c16-835a-4bf4-b4b8-1636dbabac3f', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'fb2ff16b-eb55-4fe9-a8b0-4f218c8b6e9f', '2025-11-02', '12:00:00', 60, 'America/New_York', 'completed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-11-02 18:04:56.028923-05', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('3c2e6e47-4968-4ab8-bdd6-824b3169b3ab', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', '62b2dae6-b4f3-4cd4-a270-007af8806fce', '2025-11-01', '13:00:00', 60, 'America/New_York', 'completed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-11-01 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('6805f376-0d40-4317-a506-6fae4663b5f2', '32f3acce-0f98-440d-a295-c48c64acfc46', 'c635a77a-4e3e-408a-93f3-f3f27921b859', '2025-10-31', '14:00:00', 60, 'America/New_York', 'completed', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-31 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('486fa0a8-a966-4aec-be93-72ef094e4037', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'e327bc97-dda5-4f88-a442-8891f4634c4a', '2025-10-30', '15:00:00', 60, 'America/New_York', 'completed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-30 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('d5acd261-d98d-46df-918b-8446edaec183', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', '8a5163eb-11a6-4086-9932-26a1d40f4afb', '2025-10-29', '10:00:00', 60, 'America/New_York', 'completed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-29 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('0e95ed77-dac0-42ae-9c4a-f54dc4f062f9', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', '051c3746-15de-405d-a8a3-238952be9018', '2025-10-28', '11:00:00', 60, 'America/New_York', 'completed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-28 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('94425b9e-1b28-4365-8271-83aa63065640', '56173be4-49a7-4266-9eac-07114c2007a8', 'e64d4fbf-1609-4259-b7d6-b7bf2bba7634', '2025-10-27', '12:00:00', 60, 'America/New_York', 'completed', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-27 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('512803ad-a53b-4a26-b5e6-55e7d235508c', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', '09f011d1-e002-4eb8-9017-89c39380d8d6', '2025-10-26', '13:00:00', 60, 'America/New_York', 'completed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-26 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('a6e0114c-533a-4cfd-9aa1-2b0ce3c2ffdc', '440b5bab-93b9-4f14-a9e7-66419fcde59d', '477dd26a-a28a-42a1-9aae-dde489bd01d8', '2025-10-25', '14:00:00', 60, 'America/New_York', 'completed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-25 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('b6ba3066-7307-45ef-8b33-8e065b83ce0b', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'e04b135e-4ac5-4252-8634-70af5972ac13', '2025-10-24', '15:00:00', 60, 'America/New_York', 'completed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-24 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('b58a1837-2ed5-41ea-b03a-2a39524ee63d', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', 'fb2ff16b-eb55-4fe9-a8b0-4f218c8b6e9f', '2025-10-23', '10:00:00', 60, 'America/New_York', 'completed', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-23 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('1729ab9e-c6d3-4d81-85e8-5b8cd31bc1b8', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', '62b2dae6-b4f3-4cd4-a270-007af8806fce', '2025-10-22', '11:00:00', 60, 'America/New_York', 'completed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-22 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('6f02652b-6d7b-4df9-9032-2f8d31a5fe1f', '32f3acce-0f98-440d-a295-c48c64acfc46', 'c635a77a-4e3e-408a-93f3-f3f27921b859', '2025-10-21', '12:00:00', 60, 'America/New_York', 'completed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-21 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('a8de5eb4-7ae0-4134-9c0e-daba7f631c4e', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'e327bc97-dda5-4f88-a442-8891f4634c4a', '2025-10-20', '13:00:00', 60, 'America/New_York', 'completed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-20 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('6a915aae-5f61-41a1-84ce-3c3bc3a88ae9', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', '8a5163eb-11a6-4086-9932-26a1d40f4afb', '2025-10-19', '14:00:00', 60, 'America/New_York', 'completed', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-19 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('5ae795b5-adf0-40ad-b9ac-9394ad6d52f2', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', '051c3746-15de-405d-a8a3-238952be9018', '2025-10-18', '15:00:00', 60, 'America/New_York', 'completed', 'green', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-18 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('877bf596-7e52-46bc-8d80-0a4f11c686fe', '56173be4-49a7-4266-9eac-07114c2007a8', 'e64d4fbf-1609-4259-b7d6-b7bf2bba7634', '2025-10-17', '10:00:00', 60, 'America/New_York', 'completed', 'purple', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-17 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('24ef228e-c3bf-4db8-a249-b557b4eeb299', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', '09f011d1-e002-4eb8-9017-89c39380d8d6', '2025-10-16', '11:00:00', 60, 'America/New_York', 'completed', 'orange', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-16 18:04:56.028923-04', NULL);
INSERT INTO "expert_network"."interviews" VALUES ('f075fa33-2017-4e7d-a41a-d820c73cfc77', '440b5bab-93b9-4f14-a9e7-66419fcde59d', '477dd26a-a28a-42a1-9aae-dde489bd01d8', '2025-10-15', '12:00:00', 60, 'America/New_York', 'completed', 'blue', '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05', '2025-10-15 18:04:56.028923-04', NULL);

-- ----------------------------
-- Table structure for projects
-- ----------------------------
DROP TABLE IF EXISTS "expert_network"."projects";
CREATE TABLE "expert_network"."projects" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "project_code" text COLLATE "pg_catalog"."default",
  "project_name" text COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "display_order" int4 NOT NULL DEFAULT 0,
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "updated_at" timestamptz(6) NOT NULL DEFAULT now(),
  "client_name" text COLLATE "pg_catalog"."default",
  "start_date" date,
  "end_date" date
)
;
COMMENT ON COLUMN "expert_network"."projects"."user_id" IS 'References public.user(id) from BetterAuth';
COMMENT ON COLUMN "expert_network"."projects"."project_code" IS 'Project code (e.g., ''DEAL-2025-001''). Optional but must be unique per user when provided.';
COMMENT ON COLUMN "expert_network"."projects"."client_name" IS 'Client name for the project';
COMMENT ON COLUMN "expert_network"."projects"."start_date" IS 'Project start date';
COMMENT ON COLUMN "expert_network"."projects"."end_date" IS 'Project end date';
COMMENT ON TABLE "expert_network"."projects" IS 'Top-level organizational container for campaigns';

-- ----------------------------
-- Records of projects
-- ----------------------------
INSERT INTO "expert_network"."projects" VALUES ('637bd937-e34d-43a2-bd4e-2be3ae93d19e', 'demo-user-123', 'PROJ-2024-003', 'Enterprise SaaS Due Diligence', 'Commercial diligence for SaaS enterprise software company', 2, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:26:56.366701-05', NULL, NULL, NULL);
INSERT INTO "expert_network"."projects" VALUES ('3b741b39-e352-4538-a71f-4b3ac69bc5b1', 'demo-user-123', 'PROJ-2024-002', 'FinTech Regulatory Compliance', 'Expert interviews on regulatory changes affecting FinTech companies', 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:26:56.361537-05', NULL, NULL, NULL);
INSERT INTO "expert_network"."projects" VALUES ('1e7cf7f2-8806-4677-b372-7fe4df58d29e', 'demo-user-123', 'PROJ-2024-005', 'Clean Energy Transition', 'Expert insights on renewable energy adoption and market dynamics', 4, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:26:56.367223-05', NULL, NULL, NULL);
INSERT INTO "expert_network"."projects" VALUES ('4167ef44-05b0-43b1-94f0-c594e2aeabc3', 'demo-user-123', 'PROJ-2024-004', 'Supply Chain Optimization', 'Expert network research on global supply chain challenges', 3, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:26:56.365689-05', NULL, NULL, NULL);
INSERT INTO "expert_network"."projects" VALUES ('f56fd925-8893-41eb-a877-e2d0d9fd80d8', 'demo-user-123', 'PROJ-2024-001', 'Healthcare AI Market Research', 'Comprehensive market research on AI adoption in healthcare systems', 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:26:56.365852-05', NULL, NULL, NULL);
INSERT INTO "expert_network"."projects" VALUES ('b4957e3a-df1b-4371-a1a4-0332f4ce15ac', 'demo-user-123', 'PROJ-2024-006', 'Cybersecurity Framework Analysis', 'Expert interviews on enterprise cybersecurity best practices', 5, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:26:56.367019-05', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for screening_questions
-- ----------------------------
DROP TABLE IF EXISTS "expert_network"."screening_questions";
CREATE TABLE "expert_network"."screening_questions" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "campaign_id" uuid NOT NULL,
  "parent_question_id" uuid,
  "question_text" text COLLATE "pg_catalog"."default" NOT NULL,
  "question_type" text COLLATE "pg_catalog"."default" DEFAULT 'text'::text,
  "options" jsonb,
  "display_order" int4 NOT NULL DEFAULT 0,
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "updated_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of screening_questions
-- ----------------------------
INSERT INTO "expert_network"."screening_questions" VALUES ('fd986082-aaef-4bf5-9bab-2ba3025d017a', '440b5bab-93b9-4f14-a9e7-66419fcde59d', NULL, 'What is your experience implementing clinical AI systems in hospital settings?', 'text', NULL, 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('13fcc449-e5cd-44cd-9f8f-302c1ae423d3', '440b5bab-93b9-4f14-a9e7-66419fcde59d', 'fd986082-aaef-4bf5-9bab-2ba3025d017a', 'Which AI vendors have you worked with? (Select all that apply)', 'multiple-choice', '{"options": ["Option A", "Option B", "Option C", "Option D"]}', 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('60cae1ed-ca92-4aa9-96fa-8cbeef692da0', '440b5bab-93b9-4f14-a9e7-66419fcde59d', '13fcc449-e5cd-44cd-9f8f-302c1ae423d3', 'What were the main challenges you faced during AI implementation?', 'text', NULL, 2, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('4fb017b8-1448-439d-abe8-2d3e56957c55', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', NULL, 'What is your experience with AI-powered medical imaging?', 'text', NULL, 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('428bee3f-7191-493d-95d7-1811932723e6', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', '4fb017b8-1448-439d-abe8-2d3e56957c55', 'Which imaging modalities have you worked with?', 'multiple-choice', '{"options": ["Option A", "Option B", "Option C", "Option D"]}', 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('661a3fad-d105-4764-bf31-7d03129675e5', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', '428bee3f-7191-493d-95d7-1811932723e6', 'What regulatory considerations are important for medical imaging AI?', 'text', NULL, 2, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('3d0acc73-cebf-4b68-b8fd-1269e69556b4', '7d9fc3aa-827e-4329-97b4-d9c6664aa510', '661a3fad-d105-4764-bf31-7d03129675e5', 'What regulatory considerations are important for medical imaging AI?', 'text', NULL, 3, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('7251c111-0e3f-4fdf-ad3e-ae076c7d50f1', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', NULL, 'What is your experience with digital banking compliance?', 'text', NULL, 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('7ee8ab43-74da-467a-aa0a-1693be426e23', '09d29c1d-3b60-4d19-8aeb-c28134b3f0f3', '7251c111-0e3f-4fdf-ad3e-ae076c7d50f1', 'Which regulations are most challenging for digital banking?', 'multiple-choice', '{"options": ["Option A", "Option B", "Option C", "Option D"]}', 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('0d825daf-81a3-4e19-9226-306f78d423ed', '32f3acce-0f98-440d-a295-c48c64acfc46', NULL, 'What is your experience with cryptocurrency regulations?', 'text', NULL, 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('6ecab3e7-5dba-4cbd-b7a7-2f526e67a585', '32f3acce-0f98-440d-a295-c48c64acfc46', '0d825daf-81a3-4e19-9226-306f78d423ed', 'How do you navigate SEC compliance for crypto tokens?', 'multiple-choice', '{"options": ["Option A", "Option B", "Option C", "Option D"]}', 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('0c719ef3-4e13-49dd-98dc-51ed192e71ad', '32f3acce-0f98-440d-a295-c48c64acfc46', '6ecab3e7-5dba-4cbd-b7a7-2f526e67a585', 'What are the key regulatory trends in DeFi?', 'text', NULL, 2, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('bfbcf18a-9cf1-49f1-a828-87e7db5c66ee', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', NULL, 'What pricing models have you implemented for SaaS products?', 'text', NULL, 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('d7e6b395-bd2a-4b80-a912-8da3529d48a4', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'bfbcf18a-9cf1-49f1-a828-87e7db5c66ee', 'How do you determine value-based pricing?', 'multiple-choice', '{"options": ["Option A", "Option B", "Option C", "Option D"]}', 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('d414c8fd-4cd6-48be-8d67-15c32463a0d7', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'd7e6b395-bd2a-4b80-a912-8da3529d48a4', 'What are the key considerations for usage-based pricing?', 'text', NULL, 2, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('8e5e4574-47f9-40ec-9f6b-9750c18db902', '6065f0bf-c71b-4359-ae93-c6f8dd514c87', 'd414c8fd-4cd6-48be-8d67-15c32463a0d7', 'What are the key considerations for usage-based pricing?', 'text', NULL, 3, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('f43d180f-325c-4925-b683-e6102e5361a3', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', NULL, 'What is your experience with enterprise sales processes?', 'text', NULL, 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('f867b627-8da3-4fb0-a5cd-adeeff58a680', 'fc37dc29-986b-4481-8db9-665cfb80c8cb', 'f43d180f-325c-4925-b683-e6102e5361a3', 'How do you structure account-based marketing campaigns?', 'multiple-choice', '{"options": ["Option A", "Option B", "Option C", "Option D"]}', 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('ee6626b2-77aa-46bc-b961-b6388b3c2ed7', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', NULL, 'What supply chain technology platforms have you implemented?', 'text', NULL, 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('d9ac161a-988b-4fa3-a8e6-3feaca954800', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'ee6626b2-77aa-46bc-b961-b6388b3c2ed7', 'How do you integrate WMS and TMS systems?', 'multiple-choice', '{"options": ["Option A", "Option B", "Option C", "Option D"]}', 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('f57eef42-f70e-4681-9488-ba3e5e73ad89', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'd9ac161a-988b-4fa3-a8e6-3feaca954800', 'What are the key features of an effective demand forecasting system?', 'text', NULL, 2, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('717ba392-aed2-41e9-8993-301fa926db1a', '31faa8b0-17b3-4c8e-8e8b-872016687e2b', 'f57eef42-f70e-4681-9488-ba3e5e73ad89', 'What are the key features of an effective demand forecasting system?', 'text', NULL, 3, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('d4272b14-3656-4fa6-92e2-509c128f1c8d', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', NULL, 'What is your experience with solar energy installations?', 'text', NULL, 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('6390d450-099c-47c8-8137-610f7f40e3fe', '34b4a0fc-259e-4c35-8ef5-f525af6232ff', 'd4272b14-3656-4fa6-92e2-509c128f1c8d', 'How do you evaluate solar panel technology?', 'multiple-choice', '{"options": ["Option A", "Option B", "Option C", "Option D"]}', 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('b24ca7f2-c52b-4c18-90ba-a3a755da22ed', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', NULL, 'What is your experience with battery storage technology?', 'text', NULL, 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('0114c826-4c3d-409c-a383-3b74f8dc2b45', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', 'b24ca7f2-c52b-4c18-90ba-a3a755da22ed', 'How do you compare lithium-ion vs flow batteries?', 'multiple-choice', '{"options": ["Option A", "Option B", "Option C", "Option D"]}', 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('f46c3db1-8135-463f-a7f4-d437f806c847', '08036cdf-9e42-4bfa-9d4a-2d580bf1f879', '0114c826-4c3d-409c-a383-3b74f8dc2b45', 'What are the key considerations for grid-scale energy storage?', 'text', NULL, 2, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('ac3c38a8-2f8a-40e9-aba7-a9a544f6caae', 'bead487a-b8b1-420f-8bca-ee4983b37559', NULL, 'What is your experience implementing zero trust architecture?', 'text', NULL, 0, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('813e6cda-8642-41f6-8bf3-0248cb971ed9', 'bead487a-b8b1-420f-8bca-ee4983b37559', 'ac3c38a8-2f8a-40e9-aba7-a9a544f6caae', 'Which zero trust vendors have you worked with?', 'multiple-choice', '{"options": ["Option A", "Option B", "Option C", "Option D"]}', 1, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('6a2b1ea1-fa95-4ed5-a440-731e5b58ed95', 'bead487a-b8b1-420f-8bca-ee4983b37559', '813e6cda-8642-41f6-8bf3-0248cb971ed9', 'What are the main challenges in zero trust implementation?', 'text', NULL, 2, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('830b1ea7-b84a-4ba8-9ffa-334aefaad8ca', 'bead487a-b8b1-420f-8bca-ee4983b37559', '6a2b1ea1-fa95-4ed5-a440-731e5b58ed95', 'What are the main challenges in zero trust implementation?', 'text', NULL, 3, '2025-11-04 18:04:56.028923-05', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('8dbe9155-c148-459e-9b72-94d89e50c6fd', '56173be4-49a7-4266-9eac-07114c2007a8', NULL, 'What supply chain disruptions have you experienced?', 'text', NULL, 1, '2025-11-04 18:22:39.398843-05', '2025-11-04 18:22:39.398843-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('f228908b-2af2-4d6b-91db-bd08eef6d2f9', '56173be4-49a7-4266-9eac-07114c2007a8', '8dbe9155-c148-459e-9b72-94d89e50c6fd', 'How do you diversify supplier networks?', 'text', NULL, 1, '2025-11-04 18:22:39.413132-05', '2025-11-04 18:22:39.413132-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('463c0b37-6438-4845-b136-fa1f56df3712', '504b545e-9bef-4694-a176-67feec23ba06', NULL, 'asdas', 'text', NULL, 1, '2025-11-04 19:07:43.960012-05', '2025-11-04 19:07:43.960012-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('3a88249a-3acf-4c25-a9ad-28274311cd60', '504b545e-9bef-4694-a176-67feec23ba06', NULL, 'agsd', 'text', NULL, 1, '2025-11-04 19:07:43.98498-05', '2025-11-04 19:07:43.98498-05');
INSERT INTO "expert_network"."screening_questions" VALUES ('93092e30-37f6-4bc7-954e-a5cf7a1915b6', '504b545e-9bef-4694-a176-67feec23ba06', NULL, 'war', 'text', NULL, 2, '2025-11-04 19:07:44.059471-05', '2025-11-04 19:07:44.059471-05');

-- ----------------------------
-- Table structure for team_members
-- ----------------------------
DROP TABLE IF EXISTS "expert_network"."team_members";
CREATE TABLE "expert_network"."team_members" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "email" text COLLATE "pg_catalog"."default",
  "designation" text COLLATE "pg_catalog"."default" NOT NULL,
  "avatar_url" text COLLATE "pg_catalog"."default",
  "created_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
COMMENT ON TABLE "expert_network"."team_members" IS 'Pool of team members that can be assigned to campaigns';

-- ----------------------------
-- Records of team_members
-- ----------------------------
INSERT INTO "expert_network"."team_members" VALUES ('bc55d0b8-d800-4e3c-949c-59943b9917b5', 'demo-user-123', 'Sarah Mitchell', 'sarah.mitchell@example.com', 'Research Director', '/images/team-members/Sarah Mitchell.png', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."team_members" VALUES ('f2bd664f-8432-4939-85ff-833e9c95e61f', 'demo-user-123', 'David Chen', 'david.chen@example.com', 'Senior Analyst', '/images/team-members/David Chen.png', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."team_members" VALUES ('d211ac2c-1e38-4b20-bf67-7732295ae876', 'demo-user-123', 'Emily Rodriguez', 'emily.rodriguez@example.com', 'Project Manager', '/images/team-members/Emily Rodriguez.png', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."team_members" VALUES ('6f1c8767-c3a8-4f62-b89c-46b8a3c718d5', 'demo-user-123', 'Michael Thompson', 'michael.thompson@example.com', 'Associate', '/images/team-members/Michael Thompson.png', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."team_members" VALUES ('302ae419-dd30-4f07-95ea-a8246a139e43', 'demo-user-123', 'Jennifer Kim', 'jennifer.kim@example.com', 'Analyst', '/images/team-members/Jennifer Kim.png', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."team_members" VALUES ('1344cf99-0cd4-41c7-88bd-892c16200480', 'demo-user-123', 'Robert Martinez', 'robert.martinez@example.com', 'Vice President', '/images/team-members/Robert Martinez.png', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."team_members" VALUES ('d0475de5-cc9a-4af5-b14b-bd87f494214e', 'demo-user-123', 'Lisa Anderson', 'lisa.anderson@example.com', 'Senior Manager', '/images/team-members/Lisa Anderson.png', '2025-11-04 18:04:56.028923-05');
INSERT INTO "expert_network"."team_members" VALUES ('f658da5e-5c1d-4072-99bb-5830d189e240', 'demo-user-123', 'James Wilson', 'james.wilson@example.com', 'Principal', '/images/team-members/James Wilson.png', '2025-11-04 18:04:56.028923-05');

-- ----------------------------
-- Table structure for user_ui_preferences
-- ----------------------------
DROP TABLE IF EXISTS "expert_network"."user_ui_preferences";
CREATE TABLE "expert_network"."user_ui_preferences" (
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "column_widths" jsonb NOT NULL DEFAULT '{"industry": 180, "dragHandle": 16, "campaignName": 400}'::jsonb,
  "panel_sizing" jsonb NOT NULL DEFAULT '{"chatWidth": 400, "answerWidth": 600}'::jsonb,
  "theme" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'light'::text,
  "expanded_projects" text[] COLLATE "pg_catalog"."default" DEFAULT '{}'::text[],
  "updated_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
COMMENT ON TABLE "expert_network"."user_ui_preferences" IS 'Per-user UI state and preferences';

-- ----------------------------
-- Records of user_ui_preferences
-- ----------------------------

-- ----------------------------
-- Table structure for vendor_platforms
-- ----------------------------
DROP TABLE IF EXISTS "expert_network"."vendor_platforms";
CREATE TABLE "expert_network"."vendor_platforms" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "logo_url" text COLLATE "pg_catalog"."default",
  "location" text COLLATE "pg_catalog"."default",
  "overall_score" numeric(2,1),
  "avg_cost_per_call_min" int4,
  "avg_cost_per_call_max" int4,
  "description" text COLLATE "pg_catalog"."default",
  "tags" text[] COLLATE "pg_catalog"."default" DEFAULT '{}'::text[],
  "is_active" bool NOT NULL DEFAULT true,
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "updated_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of vendor_platforms
-- ----------------------------
INSERT INTO "expert_network"."vendor_platforms" VALUES ('e9f1c2a3-4b5d-4e6f-7a8b-9c0d1e2f3a4b', 'GLG', '/images/vendor-logos/GLG.png', 'New York, USA', 4.8, 800, 1500, 'One of the world''s largest expert networks, connecting clients with industry experts across all sectors.', '{"Global Coverage","Life Sciences",Technology,"Financial Services","24h sourcing","Premium service","C-suite access","Compliance heavy","Deep bench"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.929856-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('a1b2c3d4-e5f6-4789-a123-567890abcdef', 'AlphaSights', '/images/vendor-logos/AlphaSights.png', 'London, UK', 4.7, 700, 1400, 'Premium expert network focused on connecting clients with C-suite executives and industry leaders.', '{"Executive Access","Private Equity",Consulting,"Global Project Execution","24h sourcing","White-glove service","C-suite access","EU specialists","GDPR compliant"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.929856-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('b2c3d4e5-f6a7-4801-b345-678901bcdefb', 'Guidepoint', '/images/vendor-logos/Guidepoint.png', 'New York, USA', 4.6, 750, 1300, 'Specialized in providing deep industry insights through a network of experienced professionals.', '{"Healthcare Expertise",Technology,"Quick Turnaround","48h sourcing","SME access",US-focused,"Regulatory expertise","Deep bench"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.929856-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('c3d4e5f6-a7b8-4012-c456-789012cdefab', 'Third Bridge', '/images/vendor-logos/Third Bridge.png', 'London, UK', 4.5, 600, 1200, 'Expert network with a focus on providing actionable insights for investment decisions.', '{"Investment Research","Forum Platform","APAC Coverage","48h sourcing","Self-service portal","APAC bench",Multi-region,"Cost effective"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('d4e5f6a7-b8c9-4123-d567-890123defabc', 'Atheneum', '/images/vendor-logos/Atheneum.png', 'Berlin, Germany', 4.4, 650, 1250, 'Technology-driven expert network platform with strong European presence.', '{"AI-Powered Matching","European Focus","Technology Platform","Same-day response","EU specialists","GDPR compliant",Tech-enabled,"Rapid matching"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('e5f6a7b8-c9d0-4234-e678-901234efabcd', 'Inex One', '/images/vendor-logos/Inex One.png', 'Chicago, USA', 4.3, 500, 1000, 'Expert network aggregator that connects clients with multiple expert network platforms.', '{"Multi-Network Access","Cost Effective","Platform Aggregation","72h sourcing",Self-service,Multi-vendor,Budget-friendly,"Wide coverage"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('f6a7b8c9-d0e1-4345-f789-012345fabcde', 'Coleman Research', '/images/vendor-logos/Coleman Research.png', 'Chapel Hill, USA', 4.5, 700, 1300, 'Boutique expert network focused on delivering high-quality experts for complex research projects.', '{Healthcare,Regulatory,"Boutique Service","24h sourcing","White-glove service","Compliance heavy","Niche specialists","Regulatory focus"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('a7b8c9d0-e1f2-4456-a890-123456abcdef', 'Tegus', '/images/vendor-logos/Tegus.png', 'Chicago, USA', 4.6, 800, 1500, 'Expert insights platform with a searchable library of thousands of expert transcripts.', '{"Transcript Library",Technology,"SaaS Focus","Instant access","Self-service portal","Tech platform","Searchable database",On-demand}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('b8c9d0e1-f2a3-4567-b901-234567bcdefb', 'Prosapient', '/images/vendor-logos/Prosapient.png', 'New York, USA', 4.4, 650, 1200, 'Expert network with deep industry expertise and proprietary research capabilities.', '{"Compliance Focus","Research Capabilities","Industry Depth","48h sourcing","Compliance heavy","SOC2 certified",Research-grade,"Regulated industries"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('c9d0e1f2-a3b4-4678-c012-345678cdefab', 'Stream', '/images/vendor-logos/Stream.png', 'New York, USA', 4.3, 600, 1150, 'Technology-enabled expert network focused on enterprise and technology sectors.', '{"Technology Focus","Rapid Sourcing","Flexible Pricing","24h sourcing",Tech-enabled,"Enterprise focus","Fast turnaround","Flexible terms"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('d0e1f2a3-b4c5-4789-d123-456789defabc', 'Maven', '/images/vendor-logos/Maven.png', 'San Francisco, USA', 4.5, 700, 1350, 'Platform connecting clients with vetted subject matter experts across industries.', '{User-Friendly,"Transparent Pricing",Cross-Industry,"48h sourcing","Self-service portal","Transparent fees","Easy booking","Wide expertise"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('e1f2a3b4-c5d6-4890-e234-567890efabcd', 'Dialectica', '/images/vendor-logos/Dialectica.png', 'Athens, Greece', 4.4, 550, 1100, 'Fast-growing expert network with European roots and global expansion.', '{"European Roots","Quick Turnaround","Global Expansion","24h sourcing","EU specialists","Fast response","Global reach","Cost effective"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('f2a3b4c5-d6e7-4901-f345-678901fabcde', 'Capvision', '/images/vendor-logos/Capvision.png', 'Shanghai, China', 4.3, 500, 1000, 'Leading expert network in Asia with strong China coverage.', '{"Asia Focus","China Expertise",Cross-Border,"48h sourcing","APAC bench","China specialists","Local languages",Asia-Pacific}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('a3b4c5d6-e7f8-4012-a456-789012abcdef', 'Brainworks', '/images/vendor-logos/Brainworks.png', 'New York, USA', 4.2, 600, 1200, 'Boutique expert network with personalized service and deep industry relationships.', '{Boutique,"Personalized Service","Financial Services","48h sourcing","White-glove service",Relationship-driven,"Finance focus",Personalized}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('b4c5d6e7-f8a9-4123-b567-890123bcdefb', 'Nexus', '/images/vendor-logos/Nexus.png', 'Tokyo, Japan', 4.1, 550, 1050, 'Asia-Pacific focused expert network with strong presence in Japan and Australia.', '{APAC,Japan,Manufacturing,"72h sourcing","APAC bench","Japan specialists","Regional focus",Manufacturing}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('c5d6e7f8-a9b0-4234-c678-901234cdefab', 'Zintro', '/images/vendor-logos/Zintro.png', 'Boston, USA', 4.0, 400, 900, 'Cost-effective expert network platform with self-service options.', '{"Cost Effective",Self-Service,"Quick Consultations","72h sourcing",Budget-friendly,"Self-service portal","SME access","Fast booking"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('d6e7f8a9-b0c1-4345-d789-012345defabc', 'NewtonX', '/images/vendor-logos/NewtonX.png', 'New York, USA', 4.5, 750, 1400, 'AI-powered B2B expert network specializing in hard-to-reach decision makers.', '{AI-Powered,"B2B Focus","Decision Makers","24h sourcing","AI matching","C-suite access",Hard-to-reach,Tech-enabled}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');
INSERT INTO "expert_network"."vendor_platforms" VALUES ('e7f8a9b0-c1d2-4456-e890-123456efabcd', 'ExpertConnect', '/images/vendor-logos/ExpertConnect.png', 'Singapore', 4.2, 600, 1150, 'Asian expert network with regional expertise and local language support.', '{"Asian Markets","Local Languages",Compliance,"48h sourcing","APAC bench",Multi-lingual,"Compliance focus","Regional expertise"}', 't', '2025-11-04 17:21:13.929856-05', '2025-11-04 17:21:13.940414-05');

-- ----------------------------
-- Function structure for update_updated_at_column
-- ----------------------------
DROP FUNCTION IF EXISTS "expert_network"."update_updated_at_column"();
CREATE FUNCTION "expert_network"."update_updated_at_column"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Indexes structure for table campaign_team_assignments
-- ----------------------------
CREATE INDEX "idx_campaign_team_campaign" ON "expert_network"."campaign_team_assignments" USING btree (
  "campaign_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_campaign_team_member" ON "expert_network"."campaign_team_assignments" USING btree (
  "team_member_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table campaign_team_assignments
-- ----------------------------
ALTER TABLE "expert_network"."campaign_team_assignments" ADD CONSTRAINT "campaign_team_assignments_pkey" PRIMARY KEY ("campaign_id", "team_member_id");

-- ----------------------------
-- Indexes structure for table campaign_vendor_enrollments
-- ----------------------------
CREATE INDEX "idx_enrollments_campaign" ON "expert_network"."campaign_vendor_enrollments" USING btree (
  "campaign_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_enrollments_status" ON "expert_network"."campaign_vendor_enrollments" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_enrollments_vendor" ON "expert_network"."campaign_vendor_enrollments" USING btree (
  "vendor_platform_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table campaign_vendor_enrollments
-- ----------------------------
CREATE TRIGGER "update_campaign_vendor_enrollments_updated_at" BEFORE UPDATE ON "expert_network"."campaign_vendor_enrollments"
FOR EACH ROW
EXECUTE PROCEDURE "expert_network"."update_updated_at_column"();

-- ----------------------------
-- Uniques structure for table campaign_vendor_enrollments
-- ----------------------------
ALTER TABLE "expert_network"."campaign_vendor_enrollments" ADD CONSTRAINT "enrollment_unique" UNIQUE ("campaign_id", "vendor_platform_id");

-- ----------------------------
-- Primary Key structure for table campaign_vendor_enrollments
-- ----------------------------
ALTER TABLE "expert_network"."campaign_vendor_enrollments" ADD CONSTRAINT "campaign_vendor_enrollments_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table campaigns
-- ----------------------------
CREATE INDEX "idx_campaigns_dates" ON "expert_network"."campaigns" USING btree (
  "start_date" "pg_catalog"."date_ops" ASC NULLS LAST,
  "target_completion_date" "pg_catalog"."date_ops" ASC NULLS LAST
);
CREATE INDEX "idx_campaigns_industry" ON "expert_network"."campaigns" USING btree (
  "industry_vertical" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_campaigns_order" ON "expert_network"."campaigns" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "project_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "display_order" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_campaigns_project" ON "expert_network"."campaigns" USING btree (
  "project_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_campaigns_user" ON "expert_network"."campaigns" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table campaigns
-- ----------------------------
CREATE TRIGGER "update_campaigns_updated_at" BEFORE UPDATE ON "expert_network"."campaigns"
FOR EACH ROW
EXECUTE PROCEDURE "expert_network"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table campaigns
-- ----------------------------
ALTER TABLE "expert_network"."campaigns" ADD CONSTRAINT "campaigns_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table expert_screening_responses
-- ----------------------------
CREATE INDEX "idx_responses_expert" ON "expert_network"."expert_screening_responses" USING btree (
  "expert_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_responses_question" ON "expert_network"."expert_screening_responses" USING btree (
  "screening_question_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table expert_screening_responses
-- ----------------------------
ALTER TABLE "expert_network"."expert_screening_responses" ADD CONSTRAINT "expert_screening_responses_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table experts
-- ----------------------------
CREATE INDEX "idx_experts_campaign" ON "expert_network"."experts" USING btree (
  "campaign_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_experts_campaign_status" ON "expert_network"."experts" USING btree (
  "campaign_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_experts_name" ON "expert_network"."experts" USING gin (
  "name" COLLATE "pg_catalog"."default" "public"."gin_trgm_ops"
);
CREATE INDEX "idx_experts_status" ON "expert_network"."experts" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_experts_vendor" ON "expert_network"."experts" USING btree (
  "vendor_platform_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table experts
-- ----------------------------
CREATE TRIGGER "update_experts_updated_at" BEFORE UPDATE ON "expert_network"."experts"
FOR EACH ROW
EXECUTE PROCEDURE "expert_network"."update_updated_at_column"();

-- ----------------------------
-- Checks structure for table experts
-- ----------------------------
ALTER TABLE "expert_network"."experts" ADD CONSTRAINT "experts_rating_check" CHECK (rating >= 0::numeric AND rating <= 5::numeric);
ALTER TABLE "expert_network"."experts" ADD CONSTRAINT "experts_ai_fit_score_check" CHECK (ai_fit_score >= 0 AND ai_fit_score <= 10);

-- ----------------------------
-- Primary Key structure for table experts
-- ----------------------------
ALTER TABLE "expert_network"."experts" ADD CONSTRAINT "experts_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table interviews
-- ----------------------------
CREATE INDEX "idx_interviews_campaign" ON "expert_network"."interviews" USING btree (
  "campaign_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_interviews_date" ON "expert_network"."interviews" USING btree (
  "scheduled_date" "pg_catalog"."date_ops" ASC NULLS LAST
);
CREATE INDEX "idx_interviews_expert" ON "expert_network"."interviews" USING btree (
  "expert_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_interviews_status" ON "expert_network"."interviews" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table interviews
-- ----------------------------
CREATE TRIGGER "update_interviews_updated_at" BEFORE UPDATE ON "expert_network"."interviews"
FOR EACH ROW
EXECUTE PROCEDURE "expert_network"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table interviews
-- ----------------------------
ALTER TABLE "expert_network"."interviews" ADD CONSTRAINT "interviews_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table projects
-- ----------------------------
CREATE INDEX "idx_projects_order" ON "expert_network"."projects" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "display_order" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_projects_user" ON "expert_network"."projects" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "idx_projects_user_code_unique" ON "expert_network"."projects" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "project_code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
) WHERE project_code IS NOT NULL;

-- ----------------------------
-- Triggers structure for table projects
-- ----------------------------
CREATE TRIGGER "update_projects_updated_at" BEFORE UPDATE ON "expert_network"."projects"
FOR EACH ROW
EXECUTE PROCEDURE "expert_network"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table projects
-- ----------------------------
ALTER TABLE "expert_network"."projects" ADD CONSTRAINT "projects_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table screening_questions
-- ----------------------------
CREATE INDEX "idx_screening_campaign" ON "expert_network"."screening_questions" USING btree (
  "campaign_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_screening_order" ON "expert_network"."screening_questions" USING btree (
  "campaign_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "display_order" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_screening_parent" ON "expert_network"."screening_questions" USING btree (
  "parent_question_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table screening_questions
-- ----------------------------
CREATE TRIGGER "update_screening_questions_updated_at" BEFORE UPDATE ON "expert_network"."screening_questions"
FOR EACH ROW
EXECUTE PROCEDURE "expert_network"."update_updated_at_column"();

-- ----------------------------
-- Primary Key structure for table screening_questions
-- ----------------------------
ALTER TABLE "expert_network"."screening_questions" ADD CONSTRAINT "screening_questions_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table team_members
-- ----------------------------
CREATE INDEX "idx_team_members_name" ON "expert_network"."team_members" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_team_members_user" ON "expert_network"."team_members" USING btree (
  "user_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table team_members
-- ----------------------------
ALTER TABLE "expert_network"."team_members" ADD CONSTRAINT "team_members_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table user_ui_preferences
-- ----------------------------
CREATE TRIGGER "update_user_ui_preferences_updated_at" BEFORE UPDATE ON "expert_network"."user_ui_preferences"
FOR EACH ROW
EXECUTE PROCEDURE "expert_network"."update_updated_at_column"();

-- ----------------------------
-- Checks structure for table user_ui_preferences
-- ----------------------------
ALTER TABLE "expert_network"."user_ui_preferences" ADD CONSTRAINT "user_ui_preferences_theme_check" CHECK (theme = ANY (ARRAY['light'::text, 'dark'::text]));

-- ----------------------------
-- Primary Key structure for table user_ui_preferences
-- ----------------------------
ALTER TABLE "expert_network"."user_ui_preferences" ADD CONSTRAINT "user_ui_preferences_pkey" PRIMARY KEY ("user_id");

-- ----------------------------
-- Indexes structure for table vendor_platforms
-- ----------------------------
CREATE INDEX "idx_vendors_active" ON "expert_network"."vendor_platforms" USING btree (
  "is_active" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_vendors_name" ON "expert_network"."vendor_platforms" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table vendor_platforms
-- ----------------------------
CREATE TRIGGER "update_vendor_platforms_updated_at" BEFORE UPDATE ON "expert_network"."vendor_platforms"
FOR EACH ROW
EXECUTE PROCEDURE "expert_network"."update_updated_at_column"();

-- ----------------------------
-- Uniques structure for table vendor_platforms
-- ----------------------------
ALTER TABLE "expert_network"."vendor_platforms" ADD CONSTRAINT "vendor_platforms_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table vendor_platforms
-- ----------------------------
ALTER TABLE "expert_network"."vendor_platforms" ADD CONSTRAINT "vendor_platforms_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table campaign_team_assignments
-- ----------------------------
ALTER TABLE "expert_network"."campaign_team_assignments" ADD CONSTRAINT "fk_campaign_team_campaign" FOREIGN KEY ("campaign_id") REFERENCES "expert_network"."campaigns" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "expert_network"."campaign_team_assignments" ADD CONSTRAINT "fk_campaign_team_member" FOREIGN KEY ("team_member_id") REFERENCES "expert_network"."team_members" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table campaign_vendor_enrollments
-- ----------------------------
ALTER TABLE "expert_network"."campaign_vendor_enrollments" ADD CONSTRAINT "fk_enrollment_campaign" FOREIGN KEY ("campaign_id") REFERENCES "expert_network"."campaigns" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "expert_network"."campaign_vendor_enrollments" ADD CONSTRAINT "fk_enrollment_vendor" FOREIGN KEY ("vendor_platform_id") REFERENCES "expert_network"."vendor_platforms" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table campaigns
-- ----------------------------
ALTER TABLE "expert_network"."campaigns" ADD CONSTRAINT "fk_campaigns_project" FOREIGN KEY ("project_id") REFERENCES "expert_network"."projects" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table expert_screening_responses
-- ----------------------------
ALTER TABLE "expert_network"."expert_screening_responses" ADD CONSTRAINT "fk_responses_expert" FOREIGN KEY ("expert_id") REFERENCES "expert_network"."experts" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "expert_network"."expert_screening_responses" ADD CONSTRAINT "fk_responses_question" FOREIGN KEY ("screening_question_id") REFERENCES "expert_network"."screening_questions" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table experts
-- ----------------------------
ALTER TABLE "expert_network"."experts" ADD CONSTRAINT "fk_experts_campaign" FOREIGN KEY ("campaign_id") REFERENCES "expert_network"."campaigns" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "expert_network"."experts" ADD CONSTRAINT "fk_experts_vendor" FOREIGN KEY ("vendor_platform_id") REFERENCES "expert_network"."vendor_platforms" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table interviews
-- ----------------------------
ALTER TABLE "expert_network"."interviews" ADD CONSTRAINT "fk_interviews_campaign" FOREIGN KEY ("campaign_id") REFERENCES "expert_network"."campaigns" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "expert_network"."interviews" ADD CONSTRAINT "fk_interviews_expert" FOREIGN KEY ("expert_id") REFERENCES "expert_network"."experts" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table screening_questions
-- ----------------------------
ALTER TABLE "expert_network"."screening_questions" ADD CONSTRAINT "fk_screening_campaign" FOREIGN KEY ("campaign_id") REFERENCES "expert_network"."campaigns" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "expert_network"."screening_questions" ADD CONSTRAINT "fk_screening_parent" FOREIGN KEY ("parent_question_id") REFERENCES "expert_network"."screening_questions" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
