﻿CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

START TRANSACTION;

CREATE TABLE "Roles" (
    "Id" text NOT NULL,
    "Name" character varying(256) NULL,
    "NormalizedName" character varying(256) NULL,
    "ConcurrencyStamp" text NULL,
    CONSTRAINT "PK_Roles" PRIMARY KEY ("Id")
);

CREATE TABLE "Users" (
    "Id" text NOT NULL,
    "AvatarId" text NULL,
    "UserName" character varying(256) NULL,
    "NormalizedUserName" character varying(256) NULL,
    "Email" character varying(256) NULL,
    "NormalizedEmail" character varying(256) NULL,
    "EmailConfirmed" boolean NOT NULL,
    "PasswordHash" text NULL,
    "SecurityStamp" text NULL,
    "ConcurrencyStamp" text NULL,
    "PhoneNumber" text NULL,
    "PhoneNumberConfirmed" boolean NOT NULL,
    "TwoFactorEnabled" boolean NOT NULL,
    "LockoutEnd" timestamp with time zone NULL,
    "LockoutEnabled" boolean NOT NULL,
    "AccessFailedCount" integer NOT NULL,
    CONSTRAINT "PK_Users" PRIMARY KEY ("Id")
);

CREATE TABLE "RoleClaims" (
    "Id" integer GENERATED BY DEFAULT AS IDENTITY,
    "RoleId" text NOT NULL,
    "ClaimType" text NULL,
    "ClaimValue" text NULL,
    CONSTRAINT "PK_RoleClaims" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_RoleClaims_Roles_RoleId" FOREIGN KEY ("RoleId") REFERENCES "Roles" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Folders" (
    "Id" text NOT NULL,
    "Name" character varying(255) NOT NULL,
    "UserId" text NOT NULL,
    "ParentId" text NULL,
    CONSTRAINT "PK_Folders" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Folders_Folders_ParentId" FOREIGN KEY ("ParentId") REFERENCES "Folders" ("Id"),
    CONSTRAINT "FK_Folders_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Sessions" (
    "Key" text NOT NULL,
    "AuthenticationTicketBytes" bytea NOT NULL,
    "UserId" text NOT NULL,
    CONSTRAINT "PK_Sessions" PRIMARY KEY ("Key"),
    CONSTRAINT "FK_Sessions_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "UserClaims" (
    "Id" integer GENERATED BY DEFAULT AS IDENTITY,
    "UserId" text NOT NULL,
    "ClaimType" text NULL,
    "ClaimValue" text NULL,
    CONSTRAINT "PK_UserClaims" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_UserClaims_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "UserLogins" (
    "LoginProvider" text NOT NULL,
    "ProviderKey" text NOT NULL,
    "ProviderDisplayName" text NULL,
    "UserId" text NOT NULL,
    CONSTRAINT "PK_UserLogins" PRIMARY KEY ("LoginProvider", "ProviderKey"),
    CONSTRAINT "FK_UserLogins_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "UserRoles" (
    "UserId" text NOT NULL,
    "RoleId" text NOT NULL,
    CONSTRAINT "PK_UserRoles" PRIMARY KEY ("UserId", "RoleId"),
    CONSTRAINT "FK_UserRoles_Roles_RoleId" FOREIGN KEY ("RoleId") REFERENCES "Roles" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_UserRoles_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "UserTokens" (
    "UserId" text NOT NULL,
    "LoginProvider" text NOT NULL,
    "Name" text NOT NULL,
    "Value" text NULL,
    CONSTRAINT "PK_UserTokens" PRIMARY KEY ("UserId", "LoginProvider", "Name"),
    CONSTRAINT "FK_UserTokens_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "FilesInfo" (
    "Id" text NOT NULL,
    "Name" character varying(255) NOT NULL,
    "ContentType" character varying(255) NOT NULL,
    "Size" bigint NOT NULL,
    "UserId" text NOT NULL,
    "FolderId" text NULL,
    "IsSystemFile" boolean NOT NULL,
    CONSTRAINT "PK_FilesInfo" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_FilesInfo_Folders_FolderId" FOREIGN KEY ("FolderId") REFERENCES "Folders" ("Id"),
    CONSTRAINT "FK_FilesInfo_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE INDEX "IX_FilesInfo_FolderId" ON "FilesInfo" ("FolderId");

CREATE UNIQUE INDEX "IX_FilesInfo_Name_FolderId" ON "FilesInfo" ("Name", "FolderId");

CREATE INDEX "IX_FilesInfo_UserId" ON "FilesInfo" ("UserId");

CREATE UNIQUE INDEX "IX_Folders_Name_ParentId" ON "Folders" ("Name", "ParentId");

CREATE INDEX "IX_Folders_ParentId" ON "Folders" ("ParentId");

CREATE INDEX "IX_Folders_UserId" ON "Folders" ("UserId");

CREATE INDEX "IX_RoleClaims_RoleId" ON "RoleClaims" ("RoleId");

CREATE UNIQUE INDEX "RoleNameIndex" ON "Roles" ("NormalizedName");

CREATE INDEX "IX_Sessions_UserId" ON "Sessions" ("UserId");

CREATE INDEX "IX_UserClaims_UserId" ON "UserClaims" ("UserId");

CREATE INDEX "IX_UserLogins_UserId" ON "UserLogins" ("UserId");

CREATE INDEX "IX_UserRoles_RoleId" ON "UserRoles" ("RoleId");

CREATE INDEX "EmailIndex" ON "Users" ("NormalizedEmail");

CREATE UNIQUE INDEX "UserNameIndex" ON "Users" ("NormalizedUserName");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20220713055851_Init', '6.0.5');

COMMIT;
