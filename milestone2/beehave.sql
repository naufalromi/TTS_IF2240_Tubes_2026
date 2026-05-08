-- =========================================================
-- Milestone 2 - Schema and Seed Data (MariaDB)
-- Generated using @faker-js/faker (NodeJS Faker)
-- =========================================================

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS profile_day_metric;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS tiktik_profile;
DROP TABLE IF EXISTS instagrwm_profile;
DROP TABLE IF EXISTS social_media_profile;
DROP TABLE IF EXISTS influencer_list;
DROP TABLE IF EXISTS influencer;
DROP TABLE IF EXISTS task;
DROP TABLE IF EXISTS campaign;
DROP TABLE IF EXISTS brand;
DROP TABLE IF EXISTS workspace;
DROP TABLE IF EXISTS user_account;
DROP TABLE IF EXISTS collaborates;
DROP TABLE IF EXISTS joins_user_workspace;
DROP TABLE IF EXISTS list_entry;
DROP TABLE IF EXISTS brand_telephone;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- CREATE TABLE statements
-- =========================================================

CREATE TABLE user_account (
  user_id      INT AUTO_INCREMENT PRIMARY KEY,
  username     VARCHAR(50)  NOT NULL UNIQUE,
  password     VARCHAR(255) NOT NULL
);

CREATE TABLE workspace (
  workspace_id      INT AUTO_INCREMENT PRIMARY KEY,
  workspace_name    VARCHAR(100) NOT NULL,
  subscription_plan VARCHAR(30)  NOT NULL,
  CONSTRAINT chk_subscription_plan
    CHECK (subscription_plan IN ('professional', 'business', 'enterprise'))
);

CREATE TABLE influencer (
  influencer_id             INT AUTO_INCREMENT PRIMARY KEY,
  email                     VARCHAR(100) NOT NULL UNIQUE,
  real_name                 VARCHAR(100) NOT NULL
);

CREATE TABLE joins_user_workspace (
  user_id      INT NOT NULL,
  workspace_id INT NOT NULL,
  PRIMARY KEY (user_id, workspace_id),

  FOREIGN KEY (user_id) REFERENCES user_account(user_id),
  FOREIGN KEY (workspace_id) REFERENCES workspace(workspace_id)
);

CREATE TABLE influencer_list (
  list_id      INT AUTO_INCREMENT PRIMARY KEY,
  workspace_id INT NOT NULL,
  nama_list    VARCHAR(100) NOT NULL,

  FOREIGN KEY (workspace_id) REFERENCES workspace(workspace_id)
);

CREATE TABLE list_entry (
  list_id       INT NOT NULL,
  influencer_id INT NOT NULL,
  user_id       INT NOT NULL,
  reason        VARCHAR(255),

  PRIMARY KEY (list_id, influencer_id),

  FOREIGN KEY (list_id) REFERENCES influencer_list(list_id),
  FOREIGN KEY (influencer_id) REFERENCES influencer(influencer_id),
  FOREIGN KEY (user_id) REFERENCES user_account(user_id)
);

CREATE TABLE brand (
  company_id     INT AUTO_INCREMENT PRIMARY KEY,
  workspace_id   INT NOT NULL,
  company_name   VARCHAR(100) NOT NULL,
  industry_field VARCHAR(60),
  street         VARCHAR(150),
  city           VARCHAR(60),
  province       VARCHAR(60),

  CONSTRAINT uq_companyname_per_workspace
    UNIQUE (workspace_id, company_name),

  FOREIGN KEY (workspace_id) REFERENCES workspace(workspace_id)
);

CREATE TABLE brand_telephone (
  company_id   INT NOT NULL,
  no_telephone VARCHAR(25) NOT NULL,

  PRIMARY KEY (company_id, no_telephone),

  FOREIGN KEY (company_id) REFERENCES brand(company_id)
);

CREATE TABLE campaign (
  campaign_id     INT AUTO_INCREMENT PRIMARY KEY,
  company_id      INT NOT NULL,
  campaign_title  VARCHAR(150) NOT NULL,
  campaign_status VARCHAR(30)  NOT NULL,

  CONSTRAINT chk_campaign_status
    CHECK (campaign_status IN ('draft', 'started', 'closed')),
  CONSTRAINT uq_campaigntitle_per_company
    UNIQUE (company_id, campaign_title),

  FOREIGN KEY (company_id) REFERENCES brand(company_id)
);

CREATE TABLE collaborates (
  collaborates_id      INT AUTO_INCREMENT PRIMARY KEY,
  influencer_id        INT NOT NULL,
  campaign_id          INT NOT NULL,
  collaboration_status VARCHAR(30) NOT NULL,

  CONSTRAINT chk_collaboration_status
    CHECK (collaboration_status IN ('proposed', 'accepted', 'declined', 'cancelled')),
  CONSTRAINT uq_influencer_campaign
    UNIQUE (influencer_id, campaign_id),

  FOREIGN KEY (influencer_id) REFERENCES influencer(influencer_id),
  FOREIGN KEY (campaign_id) REFERENCES campaign(campaign_id)
);

CREATE TABLE task (
  campaign_id     INT NOT NULL,
  collaborates_id INT NULL,
  task_id         INT AUTO_INCREMENT PRIMARY KEY,
  task_title      VARCHAR(150) NOT NULL,
  task_type       VARCHAR(40)  NOT NULL,
  deadline        DATE,
  price           DECIMAL(14,2),
  task_status     VARCHAR(30) NOT NULL,
  task_detail     TEXT,

  CONSTRAINT chk_task_status
    CHECK (task_status IN ('draft', 'assigned', 'done', 'missing')),  

  FOREIGN KEY (campaign_id)
    REFERENCES campaign(campaign_id),
  FOREIGN KEY (collaborates_id)
    REFERENCES collaborates(collaborates_id)
);

CREATE TABLE social_media_profile (
  social_media_profile_id INT AUTO_INCREMENT PRIMARY KEY,
  influencer_id           INT NOT NULL,
  handle                  VARCHAR(60) NOT NULL,
  followers_count         INT NOT NULL,
  verified_status         TINYINT(1) NOT NULL,
  platform VARCHAR(20) NOT NULL,

  CONSTRAINT chk_platform
    CHECK (platform IN ('instagrwm', 'tiktik')),
  CONSTRAINT uq_handle_per_platform
    UNIQUE (handle, platform),

  FOREIGN KEY (influencer_id) REFERENCES influencer(influencer_id)
);

CREATE TABLE instagrwm_profile (
  social_media_profile_id INT PRIMARY KEY,
  total_post              INT NOT NULL,

  FOREIGN KEY (social_media_profile_id) REFERENCES social_media_profile(social_media_profile_id)
);

CREATE TABLE tiktik_profile (
  social_media_profile_id INT PRIMARY KEY,
  total_like              BIGINT NOT NULL,

  FOREIGN KEY (social_media_profile_id) REFERENCES social_media_profile(social_media_profile_id)
);

CREATE TABLE post (
  post_id                 INT AUTO_INCREMENT PRIMARY KEY,
  task_id                 INT NOT NULL,
  social_media_profile_id INT NOT NULL,
  post_url                VARCHAR(255) NOT NULL UNIQUE,
  like_count              INT NOT NULL,
  view_count              INT NOT NULL,

  FOREIGN KEY (task_id) REFERENCES task(task_id),
  FOREIGN KEY (social_media_profile_id) REFERENCES social_media_profile(social_media_profile_id)
);

CREATE TABLE profile_day_metric (
  social_media_profile_id INT NOT NULL,
  metric_date             DATE NOT NULL,
  followers               INT NOT NULL,

  PRIMARY KEY (social_media_profile_id, metric_date),
  FOREIGN KEY (social_media_profile_id) REFERENCES social_media_profile(social_media_profile_id)
);