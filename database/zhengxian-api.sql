-- 正贤Api 数据库初始化脚本
-- 生成时间：2026-10-28 10:20:30
-- 管理员账号：zhengxian / 132465798（首次登录后请立即修改）
-- 默认库名：zhengxian_api_billing
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS=0;
CREATE DATABASE IF NOT EXISTS `zhengxian_api_billing` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `zhengxian_api_billing`;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `password_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `password_hash` varchar(100) NOT NULL COMMENT '密码 BCrypt hash',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='密码历史(最近N次)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_admin_operation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_admin_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `admin_id` bigint NOT NULL COMMENT '管理员用户编号',
  `admin_name` varchar(64) NOT NULL COMMENT '管理员用户名（冗余）',
  `operation_module` varchar(32) NOT NULL COMMENT '操作模块：USER，API，PACKAGE，SYSTEM，TICKET，FINANCE，OTHER',
  `operation_type` varchar(32) NOT NULL COMMENT '操作类型：CREATE，UPDATE，DELETE，QUERY，EXPORT，LOGIN，LOGOUT，OTHER',
  `operation_name` varchar(128) NOT NULL COMMENT '操作名称',
  `event_type` varchar(64) DEFAULT '' COMMENT '细分事件类型，为空沿用 operation_type',
  `target` varchar(255) DEFAULT '' COMMENT '操作对象标识（注解 SpEL 求值）',
  `struct_params` text COMMENT '结构化参数 JSON（注解 SpEL 求值，脱敏后）',
  `risk_level` varchar(16) NOT NULL DEFAULT 'LOW' COMMENT '风险级别：LOW，MEDIUM，HIGH',
  `method` varchar(16) DEFAULT NULL COMMENT '请求方法',
  `request_uri` varchar(255) DEFAULT NULL COMMENT '请求 URI',
  `request_params` text COMMENT '请求参数 JSON（脱敏后）',
  `before_data` text COMMENT '修改前数据快照',
  `after_data` text COMMENT '修改后数据快照',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '操作状态：0失败，1成功',
  `error_msg` varchar(512) DEFAULT NULL COMMENT '错误信息',
  `ip_address` varchar(64) DEFAULT NULL COMMENT '操作 IP',
  `ip_location` varchar(128) DEFAULT NULL COMMENT 'IP 归属地',
  `user_agent` varchar(512) DEFAULT NULL COMMENT '浏览器 UA',
  `cost_time` int DEFAULT NULL COMMENT '耗时（毫秒）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_admin_time` (`admin_id`,`create_time`),
  KEY `idx_module_time` (`operation_module`,`create_time`),
  KEY `idx_risk_time` (`risk_level`,`create_time`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='管理员操作日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_alert_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_alert_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `rule_id` bigint NOT NULL COMMENT '告警规则ID',
  `status` varchar(20) NOT NULL COMMENT '状态: PENDING/ALERTING/RESOLVED',
  `current_value` decimal(12,2) DEFAULT NULL COMMENT '当前指标值',
  `message` varchar(1000) DEFAULT NULL COMMENT '告警消息',
  `triggered_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '首次触发时间',
  `alerted_at` datetime DEFAULT NULL COMMENT '转正时间(状态变ALERTING)',
  `resolved_at` datetime DEFAULT NULL COMMENT '恢复时间',
  `last_evaluated_at` datetime DEFAULT NULL COMMENT '最近评估时间',
  `notification_sent` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已发通知',
  PRIMARY KEY (`id`),
  KEY `idx_alert_record_rule` (`rule_id`,`status`),
  KEY `idx_alert_record_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='告警记录';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_alert_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_alert_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '规则名称',
  `metric` varchar(50) NOT NULL COMMENT '指标: INTERFACE_ERROR_RATE/P95_LATENCY/SINGLE_API_QPS/PLATFORM_QPS/REVENUE_DROP等',
  `interface_id` bigint DEFAULT NULL COMMENT '关联接口ID(单接口指标时)',
  `threshold` decimal(12,2) NOT NULL COMMENT '阈值',
  `operator` varchar(10) NOT NULL DEFAULT '>' COMMENT '比较符: >/< >=/<= ==',
  `for_seconds` int NOT NULL DEFAULT '60' COMMENT '连续超阈值秒数才转正(防抖)',
  `interval_seconds` int NOT NULL DEFAULT '60' COMMENT '评估间隔(秒)',
  `severity` varchar(20) NOT NULL DEFAULT 'WARNING' COMMENT '级别: CRITICAL/WARNING/INFO',
  `no_data_state` varchar(20) NOT NULL DEFAULT 'OK' COMMENT '无数据时状态: OK/ALERTING/KEEP_LAST',
  `exec_err_state` varchar(20) NOT NULL DEFAULT 'KEEP_LAST' COMMENT '执行错误时状态: OK/ALERTING/KEEP_LAST',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `group_key` varchar(64) DEFAULT NULL COMMENT '告警分组',
  `repeat_seconds` int NOT NULL DEFAULT '0' COMMENT '重复通知间隔秒,0不重复',
  PRIMARY KEY (`id`),
  KEY `idx_alert_rule_metric` (`metric`),
  KEY `idx_alert_rule_enabled` (`enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='告警规则';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_alert_silence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_alert_silence` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `rule_id` bigint DEFAULT NULL COMMENT '规则ID(NULL=全局静默)',
  `start_time` datetime NOT NULL COMMENT '静默开始时间',
  `end_time` datetime NOT NULL COMMENT '静默结束时间',
  `reason` varchar(200) DEFAULT NULL COMMENT '静默原因',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否活跃',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_silence_active` (`active`,`start_time`,`end_time`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='告警静默';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_api_usage_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_api_usage_daily` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `stat_date` date NOT NULL,
  `user_id` bigint NOT NULL,
  `interface_id` bigint NOT NULL,
  `call_count` int DEFAULT '0',
  `bill_count` int DEFAULT '0',
  `cost_amount` decimal(12,4) DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_date_user_iface` (`stat_date`,`user_id`,`interface_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='接口用量日聚合表(用户×接口×日期)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_auth_flow_step`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_auth_flow_step` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `flow_code` varchar(32) NOT NULL COMMENT '流程编码，如LOGIN登录流程',
  `step_code` varchar(32) NOT NULL COMMENT '步骤编码：CAPTCHA验证码，PASSWORD密码，MFA多因素',
  `step_order` int NOT NULL DEFAULT '1' COMMENT '执行顺序，越小越先执行',
  `condition_expr` varchar(64) DEFAULT NULL COMMENT '执行条件表达式：空总是执行；mfaEnabled用户启用MFA时执行；failCount>=5失败达5次执行',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0停用，1启用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_flow_step` (`flow_code`,`step_code`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='认证流步骤配置';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_automation_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_automation_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `trigger_type` varchar(32) NOT NULL COMMENT 'SIGN_IN/STREAK_BREAK/LEVEL_UP/REFERRAL_SUCCESS/CONSUME',
  `condition_json` json DEFAULT NULL COMMENT '复用分群求值器条件树',
  `action_type` varchar(32) NOT NULL COMMENT 'SEND_MESSAGE/GRANT_POINTS/GRANT_EXP',
  `action_params` json DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `last_fired_at` datetime DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_automation_trigger` (`trigger_type`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='自动化规则';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_badge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_badge` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL COMMENT '条件码: SIGN_IN_STREAK/TOTAL_SIGN_IN/EXP/LEVEL/INVITE_COUNT/CONSUME_AMOUNT/WEEKLY_STREAK',
  `name` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `icon` varchar(64) DEFAULT 'certificate',
  `group_code` varchar(32) DEFAULT 'growth' COMMENT 'growth/signin/level/referral/consume',
  `badge_type` varchar(16) NOT NULL DEFAULT 'BRONZE' COMMENT 'BRONZE/SILVER/GOLD',
  `threshold` int NOT NULL DEFAULT '0' COMMENT '条件阈值 N',
  `multiple_grant` tinyint NOT NULL DEFAULT '0',
  `auto_revoke` tinyint NOT NULL DEFAULT '1',
  `enabled` tinyint NOT NULL DEFAULT '1',
  `grant_count` int NOT NULL DEFAULT '0',
  `sort_no` int NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_badge_code` (`code`),
  KEY `idx_badge_enabled` (`enabled`,`sort_no`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='徽章定义';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_captcha_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_captcha_config` (
  `id` tinyint NOT NULL COMMENT '主键固定1',
  `captcha_type` varchar(16) NOT NULL DEFAULT 'POW' COMMENT '验证码类型：POW工作量证明，SLIDER滑块拼图',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `pow_difficulty` tinyint NOT NULL DEFAULT '3',
  PRIMARY KEY (`id`),
  CONSTRAINT `chk_pow_difficulty` CHECK ((`pow_difficulty` between 1 and 6))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='登录验证码配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_chart_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_chart_type` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL COMMENT '图表类型标识(line/bar/pie/radar/gauge/map等)',
  `name` varchar(100) NOT NULL COMMENT '图表名称',
  `icon` varchar(100) DEFAULT NULL COMMENT '图标',
  `config_schema_json` text COMMENT '配置项schema(JSON, 前端按此渲染配置面板)',
  `render_component` varchar(200) DEFAULT NULL COMMENT '前端渲染组件名',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_chart_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='图表类型注册表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_commission_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_commission_line` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `provider_id` bigint NOT NULL,
  `rate_snapshot` decimal(10,4) NOT NULL,
  `amount` decimal(12,4) NOT NULL,
  `kind` varchar(16) NOT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单佣金明细行表(一单多服务商分佣)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_commission_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_commission_rate` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `code` varchar(32) DEFAULT NULL,
  `kind` varchar(16) NOT NULL DEFAULT 'percentage',
  `rate` decimal(10,4) NOT NULL,
  `category_id` bigint DEFAULT NULL,
  `position` int NOT NULL DEFAULT '0',
  `enabled` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='佣金费率配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_block_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_block_index` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '索引编号',
  `module` varchar(32) NOT NULL COMMENT '所属模块：helpdoc/item/notice/glossary',
  `item_id` bigint NOT NULL COMMENT '所属内容条目编号',
  `block_id` varchar(64) NOT NULL COMMENT '块标识（data-node-id 语义）',
  `block_type` varchar(32) NOT NULL COMMENT '块类型：heading/paragraph/code/table/list/quote',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '块在文档内的顺序',
  `page_no` int DEFAULT NULL COMMENT '块所属页码（长文档分块定位）',
  `text_content` text COMMENT '块纯文本（检索用）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_content_block_index` (`module`,`item_id`,`block_id`),
  KEY `idx_sys_content_block_index_item` (`module`,`item_id`,`sort_no`),
  FULLTEXT KEY `ft_sys_content_block_index_text` (`text_content`) /*!50100 WITH PARSER `ngram` */ 
) ENGINE=InnoDB AUTO_INCREMENT=212 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='块级内容检索索引';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_block_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_block_ref` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '寮曠敤缂栧彿',
  `module` varchar(32) NOT NULL COMMENT '鎵?睘妯″潡锛歨elpdoc/item',
  `item_id` bigint NOT NULL COMMENT '引用的源内容条目编号',
  `block_id` varchar(64) NOT NULL COMMENT '发起引用的块标识',
  `ref_item_id` bigint DEFAULT NULL COMMENT '被引用内容条目编号（同文档内引用时与 item_id 相同）',
  `ref_block_id` varchar(64) NOT NULL COMMENT '被引用的块标识（对应 data-type="block-ref" 的 data-id）',
  `ref_text` varchar(255) DEFAULT NULL COMMENT '引用时的块文本快照（被引用块删除后仍可溯源）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_content_block_ref` (`module`,`item_id`,`block_id`,`ref_block_id`),
  KEY `idx_sys_content_block_ref_target` (`module`,`ref_item_id`,`ref_block_id`),
  KEY `idx_sys_content_block_ref_source` (`module`,`item_id`,`block_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='块级引用关系（支持反向回溯）';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_collect_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_collect_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '瑙勫垯缂栧彿',
  `rule_name` varchar(100) NOT NULL COMMENT '瑙勫垯鍚嶇О',
  `list_url` varchar(512) NOT NULL COMMENT '列表页地址',
  `page_begin` int NOT NULL DEFAULT '1' COMMENT '璧峰?椤电爜',
  `page_end` int NOT NULL DEFAULT '1' COMMENT '缁撴潫椤电爜',
  `interval_min` int NOT NULL DEFAULT '1000' COMMENT '閲囬泦闂撮殧涓嬮檺锛堟?绉掞級',
  `interval_max` int NOT NULL DEFAULT '3000' COMMENT '閲囬泦闂撮殧涓婇檺锛堟?绉掞級',
  `target_type` varchar(32) NOT NULL DEFAULT 'page' COMMENT '入库内容类型',
  `status` varchar(20) NOT NULL DEFAULT 'READY' COMMENT '鐘舵?锛歊EADY/RUNNING/PAUSE/DONE/ERROR',
  `last_run_time` datetime DEFAULT NULL COMMENT '鏈?繎鎵ц?鏃堕棿',
  `last_message` varchar(1000) DEFAULT NULL COMMENT '鏈?繎鎵ц?淇℃伅',
  `collected_count` int NOT NULL DEFAULT '0' COMMENT '绱??閲囬泦鏉℃暟',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_content_collect_rule_name` (`rule_name`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='内容采集规则';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_i18n` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '缂栧彿',
  `module` varchar(32) NOT NULL COMMENT '鎵?睘妯″潡锛歨elpdoc/item',
  `item_id` bigint NOT NULL COMMENT '内容条目编号',
  `lang_code` varchar(16) NOT NULL COMMENT '璇?█锛歾h-CN/en-US锛堣? ContentLanguageRegistry锛',
  `title` varchar(200) DEFAULT NULL COMMENT '璇ヨ?瑷?笅鐨勬爣棰',
  `summary` varchar(500) DEFAULT NULL COMMENT '璇ヨ?瑷?笅鐨勬憳瑕',
  `content` mediumtext COMMENT '璇ヨ?瑷?笅鐨勬?鏂',
  `seo_title` varchar(150) DEFAULT NULL COMMENT '璇ヨ?瑷?笅鐨?SEO 鏍囬?',
  `seo_description` varchar(255) DEFAULT NULL COMMENT '璇ヨ?瑷?笅鐨?SEO 鎻忚堪',
  `seo_keywords` varchar(255) DEFAULT NULL COMMENT '该语言下的 SEO 关键词',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_content_i18n` (`module`,`item_id`,`lang_code`),
  KEY `idx_sys_content_i18n_lang` (`module`,`lang_code`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='内容多语言版本';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_import_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_import_source` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '数据源编号',
  `name` varchar(64) NOT NULL COMMENT '鏁版嵁婧愬悕绉',
  `driver_class` varchar(128) NOT NULL COMMENT 'JDBC 椹卞姩绫诲悕',
  `jdbc_url` varchar(512) NOT NULL COMMENT 'JDBC 杩炴帴鍦板潃',
  `username` varchar(128) DEFAULT NULL COMMENT '杩炴帴鐢ㄦ埛鍚',
  `password` varchar(255) DEFAULT NULL COMMENT '杩炴帴瀵嗙爜',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '鐘舵?锛? 鍚?敤 0 鍋滅敤',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_content_import_source_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='外部导入数据源';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_import_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_import_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '瀵煎叆浠诲姟缂栧彿',
  `source_id` bigint NOT NULL COMMENT '数据源编号',
  `source_table` varchar(128) NOT NULL COMMENT '外部源表名',
  `target_type` varchar(32) NOT NULL COMMENT '导入目标内容类型（见 ContentTypeRegistry）',
  `field_mapping` text COMMENT '瀛楁?鏄犲皠 JSON锛歔{"source":"col","target":"title"}]',
  `status` varchar(20) NOT NULL DEFAULT 'READY' COMMENT '鐘舵?锛歊EADY/RUNNING/DONE/FAILED',
  `total_count` int NOT NULL DEFAULT '0' COMMENT '婧愯〃鎬昏?鏁',
  `success_count` int NOT NULL DEFAULT '0' COMMENT '鎴愬姛瀵煎叆琛屾暟',
  `fail_count` int NOT NULL DEFAULT '0' COMMENT '失败行数',
  `last_message` varchar(1000) DEFAULT NULL COMMENT '鏈?繎鎵ц?淇℃伅',
  `last_run_time` datetime DEFAULT NULL COMMENT '鏈?繎鎵ц?鏃堕棿',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`),
  KEY `idx_sys_content_import_task_source` (`source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='外部数据批量导入任务';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '内容编号',
  `content_type` varchar(32) NOT NULL COMMENT '内容类型：notice/helpdoc/homenews/glossary/page/faq 等（注册表见 ContentTypeRegistry）',
  `title` varchar(200) NOT NULL COMMENT '标题',
  `summary` varchar(500) DEFAULT NULL COMMENT '摘要',
  `content` mediumtext COMMENT '正文',
  `draft_content` mediumtext COMMENT '草稿内容（编辑中版本）',
  `content_format` varchar(16) NOT NULL DEFAULT 'html' COMMENT '正文格式：html/markdown',
  `content_blocks` json DEFAULT NULL COMMENT '块级内容：[{id,type,content,order}]',
  `category_code` varchar(64) DEFAULT NULL COMMENT '分类标识',
  `cover_image` varchar(1024) DEFAULT NULL COMMENT '封面图地址',
  `seo_title` varchar(150) DEFAULT NULL COMMENT 'SEO 标题（留空回退 title）',
  `seo_description` varchar(255) DEFAULT NULL COMMENT 'SEO 描述',
  `seo_keywords` varchar(255) DEFAULT NULL COMMENT 'SEO 关键词（逗号分隔）',
  `lang_code` varchar(16) NOT NULL DEFAULT 'zh-CN' COMMENT '内容语言',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '上下线：1 上线 0 下线',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `publish_status` varchar(20) NOT NULL DEFAULT 'published' COMMENT '发布状态：draft/scheduled/published',
  `scheduled_time` datetime DEFAULT NULL COMMENT '定时发布时间',
  `published_at` datetime DEFAULT NULL COMMENT '首次发布时间',
  `revision_version` int NOT NULL DEFAULT '0' COMMENT '已发布版本号',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人编号',
  `updater_id` bigint DEFAULT NULL COMMENT '更新人编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_sys_content_item_type` (`content_type`,`status`,`sort_no`),
  KEY `idx_sys_content_item_publish` (`publish_status`,`scheduled_time`),
  KEY `idx_sys_content_item_lang` (`content_type`,`lang_code`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='统一内容主表（新内容类型的通用存储）';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_publish_snapshot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_publish_snapshot` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '蹇?収缂栧彿',
  `module` varchar(32) NOT NULL COMMENT '鎵?睘妯″潡',
  `item_id` bigint NOT NULL COMMENT '内容条目编号',
  `version` int NOT NULL COMMENT '版本号',
  `title` varchar(200) DEFAULT NULL COMMENT '发布时标题',
  `url` varchar(512) DEFAULT NULL COMMENT '发布时的公开地址',
  `content` mediumtext COMMENT '发布时正文快照',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_content_publish_snapshot` (`module`,`item_id`,`version`),
  KEY `idx_sys_content_publish_snapshot_item` (`module`,`item_id`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='内容发布快照';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_revision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_revision` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '鐗堟湰缂栧彿',
  `module` varchar(32) NOT NULL COMMENT '内容模块：notice/helpdoc/glossary',
  `item_id` bigint NOT NULL COMMENT '内容条目编号',
  `content` mediumtext NOT NULL COMMENT '发布快照的正文内容',
  `version` int NOT NULL COMMENT '版本号（同一条目内递增）',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_content_revision` (`module`,`item_id`,`version`),
  KEY `idx_sys_content_revision_item` (`module`,`item_id`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='内容版本历史表（发布快照，供回滚）';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_seo_push`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_seo_push` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '推送编号',
  `module` varchar(32) NOT NULL COMMENT '鎵?睘妯″潡',
  `item_id` bigint NOT NULL COMMENT '内容条目编号',
  `url` varchar(512) NOT NULL COMMENT '推送的页面地址',
  `engine` varchar(32) NOT NULL DEFAULT 'baidu' COMMENT '鎼滅储寮曟搸鏍囪瘑',
  `result` varchar(20) NOT NULL COMMENT '缁撴灉锛歋UCCESS/FAILED',
  `message` varchar(500) DEFAULT NULL COMMENT '杩斿洖淇℃伅',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '推送时间',
  PRIMARY KEY (`id`),
  KEY `idx_sys_content_seo_push_item` (`module`,`item_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SEO 推送记录';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_setting` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置编号',
  `module` varchar(32) NOT NULL COMMENT '配置模块：notice/helpdoc/homenews/friendlink/glossary',
  `config_key` varchar(64) NOT NULL COMMENT '配置键',
  `config_value` varchar(512) DEFAULT NULL COMMENT '配置值（统一按字符串存，读取时按需转换）',
  `remark` varchar(255) DEFAULT NULL COMMENT '配置说明',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_content_setting` (`module`,`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='站点级内容配置';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_content_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_content_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '妯℃澘缂栧彿',
  `name` varchar(64) NOT NULL COMMENT '妯℃澘鍚嶇О',
  `code` varchar(64) NOT NULL COMMENT '妯℃澘鏍囪瘑锛堝叕寮?〉璺?緞鐢?級',
  `module` varchar(32) NOT NULL COMMENT '閫傞厤妯″潡锛歯otice/helpdoc/homenews/glossary/page',
  `content` text NOT NULL COMMENT '妯℃澘姝ｆ枃锛屽彉閲忓舰濡?${title}',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '鐘舵?锛? 鍚?敤 0 鍋滅敤',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_content_template_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='公开页模板';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_custom_form_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_custom_form_data` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `page_code` varchar(64) NOT NULL COMMENT '页面编码',
  `form_key` varchar(64) NOT NULL COMMENT '表单标识',
  `data_json` text NOT NULL COMMENT '表单数据JSON',
  `submit_ip` varchar(64) DEFAULT NULL COMMENT '提交IP',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `page_version` bigint DEFAULT NULL COMMENT '提交时的页面版本快照id(sys_custom_page_version.id)',
  PRIMARY KEY (`id`),
  KEY `idx_form_page` (`page_code`,`form_key`),
  KEY `idx_page_version` (`page_code`,`page_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='自定义页表单提交数据';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_custom_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_custom_page` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `page_code` varchar(64) NOT NULL COMMENT '页面编码，独立URL标识，如 about',
  `route_path` varchar(128) DEFAULT NULL COMMENT '绑定的前台路由路径（如 /links），NULL 表示未接管',
  `is_official` tinyint NOT NULL DEFAULT '0' COMMENT '官方页面标记：1 官方，0 普通',
  `official_dsl` longtext COMMENT '官方基线 DSL 快照，重置时覆盖 dsl',
  `title` varchar(100) NOT NULL COMMENT '页面标题',
  `description` varchar(255) DEFAULT NULL COMMENT '页面描述',
  `dsl` longtext COMMENT 'tmagic 页面 DSL(JSON 组件树)',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态：0=下线 1=上线',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序，越小越靠前',
  `creator_id` bigint DEFAULT NULL,
  `updater_id` bigint DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_fragment` tinyint NOT NULL DEFAULT '0' COMMENT '是否为可复用碎片',
  `validation_json` text COMMENT '设计器导出的表单 JSON Schema(draft-07), 前端 ajv 与后端共用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_page_code` (`page_code`),
  UNIQUE KEY `uk_sys_custom_page_route_path` (`route_path`),
  KEY `idx_status_sort` (`status`,`sort_no`)
) ENGINE=InnoDB AUTO_INCREMENT=337 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='自定义页面';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_custom_page_form_approval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_custom_page_form_approval` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `submission_id` bigint NOT NULL,
  `node_code` int NOT NULL DEFAULT '1',
  `approver_id` bigint NOT NULL,
  `action` varchar(20) NOT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sub_node` (`submission_id`,`node_code`,`approver_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='自定义页表单审批记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_custom_page_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_custom_page_version` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `page_id` bigint NOT NULL COMMENT '页面编号',
  `dsl_json` longtext NOT NULL COMMENT '页面 DSL 快照',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_page_version` (`page_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='自定义页面版本快照';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_dashboard_dataset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dashboard_dataset` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '数据集名称',
  `name_en` varchar(100) DEFAULT NULL COMMENT '英文名称',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `description_en` varchar(255) DEFAULT NULL COMMENT '英文描述',
  `query_mode` varchar(20) NOT NULL DEFAULT 'SQL' COMMENT '查询模式: SQL/API/STATIC',
  `sql_text` text COMMENT 'SQL语句(query_mode=SQL时)',
  `api_url` varchar(500) DEFAULT NULL COMMENT 'API地址(query_mode=API时)',
  `api_method` varchar(10) DEFAULT 'GET' COMMENT 'API方法',
  `static_json` text COMMENT '静态JSON(query_mode=STATIC时)',
  `params_json` text COMMENT '查询参数定义JSON([{key,type,options,default}])',
  `db_key` varchar(50) DEFAULT 'default' COMMENT '数据源key(复用SQL-API动态数据源)',
  `cache_ttl` int NOT NULL DEFAULT '0' COMMENT '缓存秒数(0不缓存)',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_dataset_enabled` (`enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据集';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_dashboard_layout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dashboard_layout` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL COMMENT '看板标题',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `layout_json` text COMMENT '布局JSON({widgets:[{id,type,x,y,w,h,queryId,chartConfig}],filters:[],filterBindings:[],formParams:[]})',
  `is_public` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否公开(嵌入分享)',
  `share_token` varchar(64) DEFAULT NULL COMMENT '分享token(公开时使用)',
  `status` int NOT NULL DEFAULT '1' COMMENT '1启用 0禁用',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_layout_status` (`status`),
  KEY `idx_layout_share` (`share_token`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='看板布局';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_datasource_schema_snapshot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_datasource_schema_snapshot` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `datasource_id` bigint NOT NULL,
  `captured_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '快照时间',
  `tables_json` longtext NOT NULL COMMENT '表列结构JSON',
  `diff_json` text COMMENT '与上期对比的diff结果JSON',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_snapshot_ds` (`datasource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据源结构快照';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_dict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` varchar(64) NOT NULL COMMENT '字典类型标识',
  `name` varchar(64) NOT NULL COMMENT '字典名称',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1 启用，0 停用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_dict_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_dict_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dict_type` varchar(64) NOT NULL COMMENT '所属字典类型标识',
  `label` varchar(128) NOT NULL COMMENT '字典项标签',
  `value` varchar(128) NOT NULL COMMENT '字典项值',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1 启用，0 停用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_dict_item_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典项表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_doc_glossary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_doc_glossary` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '术语编号',
  `term` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '术语标识',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '弹窗显示标题',
  `summary` varchar(500) DEFAULT NULL COMMENT '术语释义摘要',
  `seo_title` varchar(150) DEFAULT NULL COMMENT 'SEO 标题',
  `seo_description` varchar(255) DEFAULT NULL COMMENT 'SEO 描述',
  `seo_keywords` varchar(255) DEFAULT NULL COMMENT 'SEO 关键词',
  `cover_image` varchar(1024) DEFAULT NULL COMMENT '封面/分享图地址',
  `lang_code` varchar(16) NOT NULL DEFAULT 'zh-CN' COMMENT '内容语言',
  `content_md` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '术语解释内容',
  `draft_content` mediumtext COMMENT '草稿内容（编辑中版本）',
  `publish_status` varchar(20) NOT NULL DEFAULT 'published' COMMENT '发布状态：draft草稿/scheduled定时待发/published已发布',
  `scheduled_time` datetime DEFAULT NULL COMMENT '定时发布时间',
  `revision_version` int NOT NULL DEFAULT '0' COMMENT '当前已发布版本号',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_demo` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1=示例数据（不可修改/删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_doc_glossary_term` (`term`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='术语词典表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_email_bounce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_email_bounce` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `bounce_type` varchar(8) NOT NULL COMMENT 'SOFT/HARD',
  `count` int NOT NULL DEFAULT '1',
  `last_reason` varchar(255) DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_bounce_email_type` (`email`,`bounce_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='邮件退信计数(SOFT×2/HARD×1 拉黑)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_email_campaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_email_campaign` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `subject` varchar(200) NOT NULL,
  `content_html` mediumtext COMMENT '支持 {{nickname}} 等占位',
  `filter_json` json DEFAULT NULL COMMENT '目标筛选(复用分群 DSL 或固定条件)',
  `segment_id` bigint DEFAULT NULL COMMENT '目标分群(优先于 filter_json)',
  `status` varchar(16) NOT NULL DEFAULT 'DRAFT' COMMENT 'DRAFT/RUNNING/PAUSED/FINISHED',
  `last_user_id` bigint NOT NULL DEFAULT '0' COMMENT '断点续发检查点',
  `total_sent` int NOT NULL DEFAULT '0',
  `total_failed` int NOT NULL DEFAULT '0',
  `total_skipped` int NOT NULL DEFAULT '0',
  `fail_threshold` decimal(5,2) NOT NULL DEFAULT '20.00' COMMENT '失败率超阈值自动 PAUSED(%)',
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_campaign_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='营销邮件活动';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_email_send_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_email_send_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `campaign_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `status` varchar(16) NOT NULL COMMENT 'SENT/FAILED/SKIPPED/BOUNCED',
  `error` varchar(255) DEFAULT NULL,
  `sent_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_campaign_user` (`campaign_id`,`user_id`),
  KEY `idx_send_log_campaign` (`campaign_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='邮件发送日志(活动+用户唯一防重)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_email_unsubscribe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_email_unsubscribe` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unsub_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='邮件退订名单';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_exp_trigger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_exp_trigger` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `threshold` bigint NOT NULL COMMENT '成长值阈值',
  `action` varchar(32) NOT NULL COMMENT 'GRANT_POINTS/SEND_MESSAGE/GRANT_EXP',
  `action_value` varchar(64) DEFAULT NULL COMMENT '积分数量/消息标题等',
  `title` varchar(100) DEFAULT NULL,
  `content` varchar(300) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_exp_trigger_threshold` (`threshold`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='成长值阈值触发器';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_exp_trigger_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_exp_trigger_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `trigger_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `fired_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_trigger_user` (`trigger_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='成长值触发日志(防重)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_experiment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_experiment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'DRAFT' COMMENT 'DRAFT/RUNNING/PAUSED/FINISHED',
  `coverage` int NOT NULL DEFAULT '100' COMMENT '放量百分比 0-100',
  `weights_json` json DEFAULT NULL COMMENT '{"A":50,"B":50}',
  `hash_attribute` varchar(32) NOT NULL DEFAULT 'anonymous_id',
  `phases_json` json DEFAULT NULL COMMENT '渐进放量 [{percent,start_time}]',
  `metric_event` varchar(40) DEFAULT NULL COMMENT '指标的 growth event_type',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_experiment_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='A/B 实验';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_experiment_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_experiment_assignment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `experiment_id` bigint NOT NULL,
  `hash_key` varchar(64) NOT NULL,
  `variant` varchar(32) NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_exp_hash` (`experiment_id`,`hash_key`),
  KEY `idx_exp_variant` (`experiment_id`,`variant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实验分流分配(幂等)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_feature_switch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_feature_switch` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `switch_key` varchar(64) NOT NULL COMMENT '开关标识',
  `switch_name` varchar(64) NOT NULL COMMENT '开关名称',
  `description` varchar(500) NOT NULL COMMENT '用途说明（前端悬浮提示展示）',
  `category` varchar(32) NOT NULL COMMENT '分类：FUND/GATEWAY/USER/NOTIFY/CONTENT/TASK',
  `enabled` tinyint NOT NULL DEFAULT '1' COMMENT '1=开启 0=关闭',
  `sort_no` int NOT NULL DEFAULT '0',
  `update_by` varchar(64) DEFAULT NULL COMMENT '最后操作人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `rollout_percent` int NOT NULL DEFAULT '100',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_switch_key` (`switch_key`),
  KEY `idx_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='功能开关管理';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_friend_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_friend_link` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '友链编号',
  `site_name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站名称',
  `site_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站地址',
  `normalized_site_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '归一化网站域名，用于去重',
  `logo_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '网站Logo地址',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '网站描述',
  `type_id` bigint DEFAULT NULL COMMENT '友链类型编号（sys_friend_link_type.id，NULL 表示未分组）',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1展示，0隐藏',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号，越小越靠前',
  `applicant_id` bigint DEFAULT NULL COMMENT '申请用户编号',
  `application_id` bigint DEFAULT NULL COMMENT '来源申请编号',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人编号',
  `updater_id` bigint DEFAULT NULL COMMENT '更新人编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_sys_friend_link_normalized_url` (`normalized_site_url`) USING BTREE,
  KEY `idx_sys_friend_link_status_sort` (`status`,`sort_no`,`id`) USING BTREE,
  KEY `idx_sys_friend_link_applicant` (`applicant_id`) USING BTREE,
  KEY `idx_sys_friend_link_type_id` (`type_id`,`status`,`sort_no`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='友情链接表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_friend_link_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_friend_link_application` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '友链申请编号',
  `user_id` bigint NOT NULL COMMENT '申请用户编号',
  `site_name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站名称',
  `site_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站地址',
  `normalized_site_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '归一化网站域名，用于去重',
  `logo_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '网站Logo地址',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '网站描述',
  `contact_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系人姓名',
  `contact_email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系邮箱',
  `contact_qq` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'QQ或微信',
  `backlink_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '已放置本站链接的页面',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING待审核、APPROVED已通过、REJECTED已驳回',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '驳回原因',
  `reviewer_id` bigint DEFAULT NULL COMMENT '审核人编号',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_friend_link_application_user` (`user_id`) USING BTREE,
  UNIQUE KEY `uk_friend_link_application_normalized_url` (`normalized_site_url`) USING BTREE,
  KEY `idx_friend_link_application_status_time` (`status`,`create_time`) USING BTREE,
  KEY `idx_friend_link_application_reviewer` (`reviewer_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='友情链接申请表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_friend_link_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_friend_link_config` (
  `id` tinyint NOT NULL COMMENT '配置编号，固定为1，全站仅一条友链配置',
  `apply_enabled` tinyint NOT NULL DEFAULT '1' COMMENT '是否允许用户申请友链：1允许，0关闭',
  `apply_notice` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '友链申请说明',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `chk_sys_friend_link_config_singleton` CHECK ((`id` = 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='友链单例配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_friend_link_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_friend_link_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '类型编号',
  `name` varchar(64) NOT NULL COMMENT '类型名称',
  `alias` varchar(64) NOT NULL COMMENT '类型标识（英文别名）',
  `display_type` tinyint NOT NULL DEFAULT '1' COMMENT '展示形态：1 文字 2 图片',
  `image_width` int DEFAULT NULL COMMENT '图片宽度（display_type=2 生效）',
  `image_height` int DEFAULT NULL COMMENT '图片高度（display_type=2 生效）',
  `description` varchar(255) DEFAULT NULL COMMENT '类型说明',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '启用状态：1 启用 0 停用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_friend_link_type_alias` (`alias`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='友链类型（分组）';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_growth_digest_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_growth_digest_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `last_sent_date` date DEFAULT NULL COMMENT '游标：上次成功发送日',
  `sent_count` int NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_digest_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='成长周报游标';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_growth_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_growth_event` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL COMMENT '登录用户(匿名事件为空，注册成功后回填)',
  `anonymous_id` varchar(64) DEFAULT NULL COMMENT '匿名标识(前端生成)',
  `event_type` varchar(40) NOT NULL COMMENT 'INVITE_LANDING_VIEW/REGISTER_SUBMIT/REGISTER_SUCCESS/FIRST_RECHARGE/FIRST_API_CALL',
  `properties` json DEFAULT NULL COMMENT '事件附加属性',
  `referral_code` varchar(32) DEFAULT NULL COMMENT '邀请码',
  `utm_source` varchar(64) DEFAULT NULL,
  `utm_medium` varchar(64) DEFAULT NULL,
  `utm_campaign` varchar(64) DEFAULT NULL,
  `utm_content` varchar(64) DEFAULT NULL,
  `utm_term` varchar(64) DEFAULT NULL,
  `page_path` varchar(255) DEFAULT NULL,
  `client_ip` varchar(64) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_growth_event_type_time` (`event_type`,`create_time`),
  KEY `idx_growth_event_user` (`user_id`),
  KEY `idx_growth_event_anon` (`anonymous_id`),
  KEY `idx_growth_event_referral` (`referral_code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='增长事件埋点';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_growth_goal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_growth_goal` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `match_type` varchar(30) NOT NULL COMMENT 'FIRST_RECHARGE_AMOUNT/PACKAGE_OPEN/FIRST_API_CALL',
  `threshold` decimal(12,2) DEFAULT NULL COMMENT '阈值(如首充≥50)',
  `event_type` varchar(40) DEFAULT NULL COMMENT '对应埋点事件',
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_goal_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='增长转化目标';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_growth_goal_conversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_growth_goal_conversion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `goal_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `source_type` varchar(20) DEFAULT NULL COMMENT '首触/注册来源快照',
  `source_ref` varchar(64) DEFAULT NULL COMMENT '邀请码/UTM',
  `amount` decimal(12,2) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_goal_user` (`goal_id`,`user_id`),
  KEY `idx_goal_conv_time` (`goal_id`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='转化目标达成记录';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_growth_message_flow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_growth_message_flow` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL,
  `trigger_type` varchar(40) NOT NULL COMMENT 'COMMISSION_FIRST_EARNED/REFEREE_FIRST_RECHARGE/WITHDRAW_SUCCESS',
  `delay_minutes` int NOT NULL DEFAULT '0',
  `title_template` varchar(200) NOT NULL,
  `content_template` varchar(500) NOT NULL,
  `channel` varchar(16) NOT NULL DEFAULT 'SITE',
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_flow_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='里程碑消息流(简化 drip)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_help_doc_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_help_doc_article` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_id` bigint NOT NULL,
  `title` varchar(150) NOT NULL,
  `summary` varchar(255) DEFAULT '',
  `seo_title` varchar(150) DEFAULT NULL COMMENT 'SEO 标题',
  `seo_description` varchar(255) DEFAULT NULL COMMENT 'SEO 描述',
  `seo_keywords` varchar(255) DEFAULT NULL COMMENT 'SEO 关键词',
  `cover_image` varchar(1024) DEFAULT NULL COMMENT '封面/分享图地址',
  `lang_code` varchar(16) NOT NULL DEFAULT 'zh-CN' COMMENT '内容语言',
  `content_html` mediumtext,
  `content_blocks` json DEFAULT NULL COMMENT '块级内容：[{id,type,content,order}]',
  `draft_content` mediumtext COMMENT '草稿内容（编辑中版本）',
  `publish_status` varchar(20) NOT NULL DEFAULT 'published' COMMENT '发布状态：draft草稿/scheduled定时待发/published已发布',
  `scheduled_time` datetime DEFAULT NULL COMMENT '定时发布时间',
  `revision_version` int NOT NULL DEFAULT '0' COMMENT '当前已发布版本号',
  `views` bigint DEFAULT '0',
  `sort_no` int DEFAULT '0',
  `status` tinyint DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `publish_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_publish` (`publish_at`),
  FULLTEXT KEY `ft_content` (`title`,`summary`,`content_html`) /*!50100 WITH PARSER `ngram` */ 
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='帮助文档文章表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_help_doc_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_help_doc_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `icon` varchar(128) DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `sort_no` int DEFAULT '0',
  `status` tinyint DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='帮助文档分类表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_help_doc_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_help_doc_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='帮助文档标签';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_help_doc_tag_rel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_help_doc_tag_rel` (
  `article_id` bigint NOT NULL,
  `tag_id` bigint NOT NULL,
  PRIMARY KEY (`article_id`,`tag_id`),
  KEY `idx_tag` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='帮助文章-标签关联';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_home_news_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_home_news_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `header_en` varchar(100) DEFAULT '',
  `header_image` varchar(255) DEFAULT '',
  `sort_no` int DEFAULT '0',
  `status` tinyint DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='首页动态分类表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_home_news_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_home_news_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_id` bigint NOT NULL,
  `title` varchar(150) NOT NULL,
  `summary` varchar(500) DEFAULT '',
  `seo_title` varchar(150) DEFAULT NULL COMMENT 'SEO 标题',
  `seo_description` varchar(255) DEFAULT NULL COMMENT 'SEO 描述',
  `seo_keywords` varchar(255) DEFAULT NULL COMMENT 'SEO 关键词',
  `cover_image` varchar(1024) DEFAULT NULL COMMENT '封面/分享图地址',
  `lang_code` varchar(16) NOT NULL DEFAULT 'zh-CN' COMMENT '内容语言',
  `publish_date` date DEFAULT NULL,
  `sort_no` int DEFAULT '0',
  `status` tinyint DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `publish_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_publish` (`publish_at`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='首页动态条目表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_home_notice_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_home_notice_config` (
  `id` tinyint NOT NULL COMMENT '配置编号，固定为1，全站仅一条首页滚动公告',
  `enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否启用首页滚动公告：1启用，0禁用',
  `content` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '首页滚动公告内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `chk_sys_home_notice_config_singleton` CHECK ((`id` = 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='首页滚动公告单例配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_interface_api`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_interface_api` (
  `avatar_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '接口头像地址',
  `avatar_icon` varchar(128) DEFAULT NULL COMMENT '图标库图标名称，如 lucide:boxes',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '接口编号',
  `api_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '接口唯一编码',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '接口名称',
  `category_id` bigint DEFAULT NULL COMMENT '接口分类编号',
  `provider_id` bigint DEFAULT NULL COMMENT '归属服务商用户编号，NULL表示官方自营',
  `request_url` varchar(1024) DEFAULT NULL COMMENT '第三方接口地址，SQL 类型接口为空',
  `source_type` varchar(16) NOT NULL DEFAULT 'HTTP' COMMENT '接口来源 HTTP/SQL',
  `polling_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否开启上游轮询：1开启，0关闭',
  `polling_mode` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ROUND_ROBIN' COMMENT '轮询方式：ROUND_ROBIN普通轮询，PRIMARY主接口',
  `upstream_urls` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '上游接口地址列表JSON数组，支持每个上游独立配置响应校验',
  `backends` text COMMENT '声明式后端聚合JSON数组(krakend风格)，每项: url/method/timeout毫秒/group归组/allow字段白名单/qpsLimit后端限流；少于2项时按单后端原样转发',
  `rate_limit_smoothing` text COMMENT '限流平滑配置JSON(tyk风格): threshold兜底限额/triggerThreshold触发系数(0~1)/step步长/delay调整间隔秒；未配置则维持硬限',
  `mock_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '声明式Mock开关：1启用后命中直接返回Mock响应不再转发上游',
  `mock_response_body` mediumtext COMMENT '声明式Mock响应体',
  `mock_status_code` int NOT NULL DEFAULT '200' COMMENT '声明式Mock响应状态码',
  `mock_delay_ms` int NOT NULL DEFAULT '0' COMMENT '声明式Mock响应延迟毫秒',
  `polling_check_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否开启轮询响应JSON字段校验：1开启，0关闭',
  `polling_check_field` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'code' COMMENT '轮询响应校验JSON字段路径，例如code或data.status',
  `polling_check_expected` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '200' COMMENT '轮询响应校验期望值，不匹配则切换下一上游',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '请求方式：GET、POST、GET_POST',
  `forward_content_type` varchar(50) DEFAULT NULL COMMENT '涓婃父璇锋眰浣撶紪鐮侊細json/urlencoded/plain锛岀暀绌烘寜榛樿?',
  `limit_by` varchar(16) NOT NULL DEFAULT 'USER' COMMENT '限流标识维度: USER用户/IP地址/API_KEY密钥',
  `price` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT '接口价格',
  `point_price` bigint NOT NULL DEFAULT '0' COMMENT '单次调用扣除点数',
  `is_top` tinyint NOT NULL DEFAULT '0' COMMENT '是否置顶：1置顶，0普通',
  `is_featured` tinyint NOT NULL DEFAULT '0' COMMENT '是否精选：首页展示开关，1精选，0普通',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0=下架 1=启用(上架) 2=待上架 3=已弃用(网关可调,响应带Deprecation/Sunset头) 4=已退役(网关410)',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '软删除标记：0未删除，1已删除',
  `audit_status` tinyint NOT NULL DEFAULT '1' COMMENT '审核状态：0待审核，1已通过，2已驳回',
  `audit_remark` varchar(500) DEFAULT NULL COMMENT '接口审核备注或驳回原因',
  `deprecate_time` datetime DEFAULT NULL COMMENT '弃用时间：状态流转到3(已弃用)时写入',
  `sunset_hint` varchar(255) DEFAULT NULL COMMENT '弃用提示：替代接口说明或下线计划，展示给调用方',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '描述',
  `doc_summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公开接口文档描述，未配置时使用描述',
  `doc_response_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'JSON' COMMENT '公开接口文档返回方式：JSON、TEXT、XML、HTML、FILE',
  `doc_preferred_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公开接口文档推荐请求方式：GET、POST',
  `doc_request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '公开接口文档请求参数JSON数组，不包含密钥',
  `doc_response_fields` longtext,
  `doc_response_example` longtext,
  `doc_status_codes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '公开接口文档状态码JSON数组',
  `doc_notice` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公开接口文档免责声明或提示',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `stats_opt_in` tinyint NOT NULL DEFAULT '1' COMMENT '是否同意纳入平台统计大屏 0否 1是',
  `circuit_breaker_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '接口熔断开关',
  `circuit_error_threshold` int NOT NULL DEFAULT '5' COMMENT '熔断错误数阈值',
  `circuit_window_s` int NOT NULL DEFAULT '60' COMMENT '熔断统计窗口(秒)',
  `draft_content` text COMMENT '草稿内容JSON，发布后置空',
  `draft_update_time` datetime DEFAULT NULL COMMENT '草稿最后保存时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_sys_interface_api_code` (`api_code`) USING BTREE,
  KEY `idx_sys_interface_api_top` (`is_top`,`id`) USING BTREE,
  KEY `idx_sys_interface_api_featured` (`status`,`is_featured`,`is_top`,`id`) USING BTREE,
  KEY `idx_sys_interface_api_status` (`status`) USING BTREE,
  KEY `idx_sys_interface_api_method` (`request_method`) USING BTREE,
  KEY `idx_sys_interface_api_provider_status` (`provider_id`,`status`,`audit_status`),
  KEY `idx_interface_source` (`source_type`),
  KEY `idx_sys_interface_api_lifecycle` (`status`,`deprecate_time`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='接口配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_interface_api_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_interface_api_review` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `api_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `rating` tinyint NOT NULL,
  `content` varchar(500) DEFAULT NULL,
  `reply` varchar(500) DEFAULT NULL,
  `status` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_api_user` (`api_id`,`user_id`),
  KEY `idx_api` (`api_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='接口评价表(用户评分与回复)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_interface_billing_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_interface_billing_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '扣费规则编号',
  `interface_id` bigint NOT NULL COMMENT '接口编号',
  `field_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '返回字段名，默认code，支持响应JSON字段路径',
  `operator` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '比较方式：EQ等于、NE不等于、GT大于、LT小于、CONTAINS包含',
  `expected_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '期望值',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_interface_billing_rule_api` (`interface_id`) USING BTREE,
  KEY `idx_interface_billing_rule_sort` (`interface_id`,`sort_no`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='接口扣费规则表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_interface_call_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_interface_call_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '调用日志编号',
  `user_id` bigint NOT NULL COMMENT '调用用户编号',
  `tenant_id` bigint DEFAULT NULL COMMENT '租户编号(成员调用时冗余,组织用量聚合)',
  `interface_id` bigint NOT NULL COMMENT '接口编号',
  `api_key_id` bigint DEFAULT NULL COMMENT '调用使用的密钥编号',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实际请求方式',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '请求参数',
  `client_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端真实IP',
  `client_region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端IP归属完整地区',
  `client_country` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端IP归属国家或地区',
  `client_province` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端IP归属省级地区',
  `client_province_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端IP归属省级行政区划代码',
  `client_city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端IP归属城市',
  `client_isp` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端网络运营商',
  `client_geo_source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端归属来源：HEADER、LOCAL、UNKNOWN',
  `upstream_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '本次实际请求的上游地址',
  `upstream_switched` tinyint NOT NULL DEFAULT '0' COMMENT '是否发生上游切换：1是，0否',
  `polling_mode` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'SINGLE' COMMENT '本次使用的轮询模式：SINGLE、ROUND_ROBIN、PRIMARY',
  `response_status` int DEFAULT NULL COMMENT '响应状态码',
  `response_body` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '响应内容',
  `success` tinyint NOT NULL DEFAULT '0' COMMENT '是否成功：1成功，0失败',
  `billable` tinyint NOT NULL DEFAULT '0' COMMENT '是否计费：1计费，0不计费',
  `charge_amount` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT '本次计费金额',
  `charge_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'FREE' COMMENT '扣费来源：POINT点数、BALANCE余额、MEMBER会员、FREE免费、ADMIN管理员测试',
  `charge_scope` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'FREE' COMMENT '实际扣费层级：GLOBAL全站套餐、INTERFACE接口套餐、POINT点数、BALANCE余额、FREE免费、ADMIN管理员测试',
  `charge_package_id` bigint DEFAULT NULL COMMENT '扣费套餐开通记录编号',
  `charge_rule_snapshot` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '扣费规则快照',
  `elapsed_ms` bigint NOT NULL DEFAULT '0' COMMENT '调用耗时毫秒',
  `error_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '错误信息',
  `trace_id` varchar(64) DEFAULT NULL COMMENT '链路追踪ID',
  `error_code` varchar(64) DEFAULT NULL COMMENT '标准错误码',
  `result_rows` int DEFAULT NULL COMMENT 'SQL接口返回行数',
  `canary_hit` tinyint NOT NULL DEFAULT '0' COMMENT '是否命中灰度：1是，0否',
  `provider_id` bigint DEFAULT NULL COMMENT '服务商用户编号',
  `provider_revenue` decimal(12,4) DEFAULT NULL COMMENT '服务商本次分成收益',
  `user_visible` tinyint NOT NULL DEFAULT '1' COMMENT '用户侧是否可见：1可见，0隐藏',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sys_interface_call_log_user` (`user_id`) USING BTREE,
  KEY `idx_sys_interface_call_log_interface` (`interface_id`) USING BTREE,
  KEY `idx_sys_interface_call_log_user_interface_time` (`user_id`,`interface_id`,`create_time`) USING BTREE,
  KEY `idx_sys_interface_call_log_user_time` (`user_id`,`create_time`) USING BTREE,
  KEY `idx_sys_interface_call_log_user_visible_time` (`user_id`,`user_visible`,`create_time`) USING BTREE,
  KEY `idx_sys_interface_call_log_client_ip` (`client_ip`) USING BTREE,
  KEY `idx_sys_interface_call_log_region` (`client_province_code`,`client_province`) USING BTREE,
  KEY `idx_sys_interface_call_log_charge_scope` (`charge_scope`,`charge_package_id`) USING BTREE,
  KEY `idx_sys_interface_call_log_scope_package_time` (`charge_scope`,`charge_package_id`,`create_time`) USING BTREE,
  KEY `idx_sys_interface_call_log_create_time` (`create_time`) USING BTREE,
  KEY `idx_log_interface_time` (`interface_id`,`create_time`,`billable`),
  KEY `idx_call_log_provider_time` (`provider_id`,`create_time`),
  KEY `idx_call_log_trace` (`trace_id`),
  KEY `idx_sys_interface_call_log_key_time` (`api_key_id`,`create_time`),
  KEY `idx_sys_interface_call_log_provider_time` (`provider_id`,`create_time`),
  KEY `idx_call_log_tenant_time` (`tenant_id`,`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='接口调用日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_interface_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_interface_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类编号',
  `name` varchar(64) NOT NULL COMMENT '分类名称',
  `icon` varchar(128) DEFAULT NULL COMMENT '分类图标',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_interface_category_name` (`name`),
  KEY `idx_sys_interface_category_sort` (`sort_no`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='接口分类表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_interface_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_interface_subscription` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `interface_id` bigint NOT NULL COMMENT '接口编号',
  `user_id` bigint NOT NULL COMMENT '订阅用户',
  `reason` varchar(500) DEFAULT NULL COMMENT '申请原因',
  `status` varchar(16) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/APPROVED/REJECTED/UNSUBSCRIBED',
  `approver` bigint DEFAULT NULL COMMENT '审批人',
  `opinion` varchar(500) DEFAULT NULL COMMENT '审批意见',
  `expire_time` datetime DEFAULT NULL COMMENT '订阅到期时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_interface_user` (`interface_id`,`user_id`),
  KEY `idx_sub_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='消费者接口订阅';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ip_blacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ip_blacklist` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` varchar(16) NOT NULL COMMENT '类型：BLACK 黑名单，WHITE 白名单',
  `ip_start` varchar(64) NOT NULL COMMENT '起始 IP 或单个 IP',
  `ip_end` varchar(64) DEFAULT NULL COMMENT '结束 IP（范围模式时填写，单 IP 为 NULL）',
  `cidr` varchar(64) DEFAULT NULL COMMENT 'CIDR 原文（如 192.168.1.0/24，仅 IPv4）',
  `ip_numeric_start` bigint unsigned DEFAULT NULL COMMENT '起始 IP 数值化（仅 IPv4，便于排查与核对）',
  `ip_numeric_end` bigint unsigned DEFAULT NULL COMMENT '结束 IP 数值化（仅 IPv4）',
  `ip_version` tinyint NOT NULL DEFAULT '4' COMMENT 'IP 版本：4 / 6',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注（封禁原因等）',
  `source` varchar(32) NOT NULL DEFAULT 'MANUAL' COMMENT '来源：MANUAL 手动添加，AUTO 自动封禁',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间（NULL = 永久有效）',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1 启用，0 禁用',
  `create_by` bigint DEFAULT NULL COMMENT '创建人用户 ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_sys_ip_blacklist_type_status` (`type`,`status`),
  KEY `idx_sys_ip_blacklist_expire` (`expire_time`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统级 IP 黑白名单表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ip_block_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ip_block_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `ip_address` varchar(64) NOT NULL COMMENT '被拦截的 IP',
  `block_type` varchar(16) NOT NULL COMMENT '拦截类型：BLACKLIST 黑名单，RATE_LIMIT 限流，OTHER 其他',
  `request_uri` varchar(255) DEFAULT NULL COMMENT '请求 URI',
  `user_agent` varchar(512) DEFAULT NULL COMMENT '浏览器 User-Agent',
  `matched_rule_id` bigint DEFAULT NULL COMMENT '命中的规则 ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '拦截时间',
  PRIMARY KEY (`id`),
  KEY `idx_sys_ip_block_log_ip` (`ip_address`,`create_time`),
  KEY `idx_sys_ip_block_log_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='IP 拦截日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_leaderboard_score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_leaderboard_score` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `leaderboard_code` varchar(32) NOT NULL COMMENT 'SIGN_IN_STREAK/GROWTH_EXP/REFERRAL_INVITE',
  `user_id` bigint NOT NULL,
  `stat_date` date NOT NULL,
  `score` bigint NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_leaderboard_user_date` (`leaderboard_code`,`user_id`,`stat_date`),
  KEY `idx_leaderboard_date` (`leaderboard_code`,`stat_date`,`score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='排行榜日聚合';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_link_click`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_link_click` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `link_id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `anonymous_id` varchar(64) DEFAULT NULL,
  `client_ip` varchar(64) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_click_link` (`link_id`),
  KEY `idx_click_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='短链点击记录';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_log_archive_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_log_archive_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `source_table` varchar(50) NOT NULL COMMENT '源日志表(interface_call_log/login_log/user_operation_log/admin_operation_log)',
  `retention_days` int NOT NULL DEFAULT '90' COMMENT '主表保留天数',
  `archive_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用归档',
  `archive_day_of_month` int NOT NULL DEFAULT '1' COMMENT '每月归档日(1-28)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_log_archive_table` (`source_table`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='日志归档配置';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_log_archive_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_log_archive_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `source_table` varchar(50) NOT NULL COMMENT '源日志表',
  `archive_month` varchar(7) NOT NULL COMMENT '归档月份(YYYY-MM)',
  `record_count` bigint NOT NULL DEFAULT '0' COMMENT '归档记录数',
  `archived_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '归档时间',
  `archive_file` varchar(500) DEFAULT NULL COMMENT '归档文件路径(Excel导出)',
  PRIMARY KEY (`id`),
  KEY `idx_archive_table_month` (`source_table`,`archive_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='日志归档记录';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_login_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint DEFAULT NULL COMMENT '用户 ID（登录失败且用户不存在时为空）',
  `username` varchar(64) NOT NULL COMMENT '登录账号（输入值）',
  `log_type` varchar(16) NOT NULL COMMENT '日志类型：LOGIN 登录，LOGOUT 退出',
  `ip` varchar(64) DEFAULT NULL COMMENT '登录 IP',
  `user_agent` varchar(512) DEFAULT NULL COMMENT '浏览器 User-Agent',
  `trace_id` varchar(64) DEFAULT NULL COMMENT '链路追踪 ID',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1 成功，0 失败',
  `message` varchar(255) DEFAULT NULL COMMENT '说明（失败原因等）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_login_log_user` (`user_id`),
  KEY `idx_login_log_time` (`create_time`),
  KEY `idx_login_log_trace` (`trace_id`)
) ENGINE=InnoDB AUTO_INCREMENT=415 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='登录日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_member_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_member_level` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `level` int NOT NULL COMMENT '等级数字（1, 2, 3...）',
  `name` varchar(64) NOT NULL COMMENT '等级名称（如"青铜"、"白银"）',
  `required_exp` bigint NOT NULL DEFAULT '0' COMMENT '所需成长值',
  `color` varchar(16) DEFAULT '#6b7280' COMMENT '等级颜色',
  `icon` varchar(128) DEFAULT NULL COMMENT '图标',
  `discount_bonus` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT '折扣加成（如 0.05 = 在原价基础上再打95折）',
  `qps_bonus` int NOT NULL DEFAULT '0' COMMENT 'QPS 加成（额外增加的 QPS）',
  `daily_limit_bonus` bigint NOT NULL DEFAULT '0' COMMENT '日调用次数加成',
  `benefits` text COMMENT '权益描述 JSON',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0停用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `upgrade_requirements` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_member_level` (`level`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员等级配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单编号',
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父级菜单编号',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '前端路由名称',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '前端路由路径',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '前端组件路径',
  `link_src` varchar(512) DEFAULT NULL COMMENT '外链/内嵌菜单地址（type=link 取 meta.link，type=embedded 取 meta.iframeSrc）',
  `redirect` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '重定向路径',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单标题或国际化键',
  `icon` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '菜单图标',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'menu' COMMENT '菜单类型：目录、菜单、内嵌页、外链、按钮',
  `permission` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '按钮或接口权限码',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `affix_tab` tinyint DEFAULT NULL COMMENT '是否固定标签页：1是，0否',
  `keep_alive` tinyint DEFAULT NULL COMMENT '是否缓存页面：1是，0否',
  `hide_in_menu` tinyint DEFAULT NULL COMMENT '是否在菜单隐藏：1是，0否',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sys_menu_parent` (`parent_id`) USING BTREE,
  KEY `idx_sys_menu_permission` (`permission`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9241 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统菜单表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_message_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_message_template` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL COMMENT '浜嬩欢code锛岃?浜嬩欢娓呭崟',
  `name` varchar(64) NOT NULL COMMENT '模板名称（管理端展示）',
  `notify_type` varchar(32) NOT NULL DEFAULT 'SYSTEM' COMMENT '瀵瑰簲 sys_notify_type.code',
  `title_template` varchar(128) NOT NULL,
  `content_template` varchar(1000) NOT NULL,
  `variables_json` varchar(1000) DEFAULT NULL COMMENT '变量说明 [{"key":"nickname","desc":"用户昵称"}]',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1 鍚?敤 0 鍋滅敤',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tpl_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='站内信事件模板';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_monitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_monitor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '监控名称',
  `type` varchar(20) NOT NULL DEFAULT 'HTTP' COMMENT '类型: HTTP/TCP/DNS/PING',
  `target` varchar(500) NOT NULL COMMENT '目标地址(url或host:port)',
  `interval_seconds` int NOT NULL DEFAULT '60' COMMENT '探测间隔(秒)',
  `timeout_seconds` int NOT NULL DEFAULT '10' COMMENT '超时(秒)',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `expected_status_code` int DEFAULT '200' COMMENT 'HTTP期望状态码(仅HTTP)',
  `expected_keyword` varchar(200) DEFAULT NULL COMMENT 'HTTP期望关键词(仅HTTP)',
  `port` int DEFAULT NULL COMMENT '端口(TCP/PING)',
  `dns_server` varchar(100) DEFAULT NULL COMMENT 'DNS服务器(仅DNS)',
  `dns_record_type` varchar(10) DEFAULT 'A' COMMENT 'DNS记录类型(仅DNS)',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_monitor_enabled` (`enabled`),
  KEY `idx_monitor_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='服务可用性监控项';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_monitor_heartbeat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_monitor_heartbeat` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `monitor_id` bigint NOT NULL COMMENT '监控项ID',
  `status` varchar(20) NOT NULL COMMENT 'UP/DOWN/PENDING',
  `ping_ms` int DEFAULT NULL COMMENT '响应耗时(毫秒)',
  `status_code` int DEFAULT NULL COMMENT 'HTTP状态码(仅HTTP)',
  `message` varchar(500) DEFAULT NULL COMMENT '探测消息',
  `check_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '探测时间',
  PRIMARY KEY (`id`),
  KEY `idx_heartbeat_monitor` (`monitor_id`,`check_time`),
  KEY `idx_heartbeat_check_time` (`check_time`)
) ENGINE=InnoDB AUTO_INCREMENT=10150 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='监控心跳记录';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告编号',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `content_html` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告富文本内容',
  `draft_content` mediumtext COMMENT '草稿内容（编辑中版本，NULL 表示与已发布一致）',
  `publish_status` varchar(20) NOT NULL DEFAULT 'published' COMMENT '发布状态：draft草稿/scheduled定时待发/published已发布',
  `scheduled_time` datetime DEFAULT NULL COMMENT '定时发布时间（publish_status=scheduled 时生效）',
  `revision_version` int NOT NULL DEFAULT '0' COMMENT '当前已发布版本号，0 表示从未通过版本机制发布',
  `summary` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公告摘要',
  `seo_title` varchar(150) DEFAULT NULL COMMENT 'SEO 标题',
  `seo_description` varchar(255) DEFAULT NULL COMMENT 'SEO 描述',
  `seo_keywords` varchar(255) DEFAULT NULL COMMENT 'SEO 关键词',
  `cover_image` varchar(1024) DEFAULT NULL COMMENT '封面/分享图地址',
  `lang_code` varchar(16) NOT NULL DEFAULT 'zh-CN' COMMENT '内容语言',
  `is_top` tinyint NOT NULL DEFAULT '0' COMMENT '是否置顶：1置顶，0普通',
  `is_popup` tinyint NOT NULL DEFAULT '0' COMMENT '是否每日弹窗：1弹窗，0不弹窗',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1发布，0隐藏',
  `publish_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人编号',
  `updater_id` bigint DEFAULT NULL COMMENT '更新人编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sys_notice_status_top_time` (`status`,`is_top`,`publish_time`) USING BTREE,
  KEY `idx_sys_notice_status_popup_time` (`status`,`is_popup`,`publish_time`) USING BTREE,
  KEY `idx_sys_notice_publish_time` (`publish_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='公告表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_notification_channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notification_channel` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '渠道名称',
  `type` varchar(20) NOT NULL COMMENT '类型: WEBHOOK/EMAIL/FEISHU',
  `config_json` text COMMENT '渠道配置JSON(webhookUrl/smtpConfig/feishuWebhook等)',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notif_channel_type` (`type`),
  KEY `idx_notif_channel_enabled` (`enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知渠道配置';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_notify_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notify_type` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `name` varchar(64) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1 启用 0 停用',
  `user_closable` tinyint NOT NULL DEFAULT '1' COMMENT '用户是否可关闭 1可 0强制下发',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_notify_type_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='站内信通知类型注册表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_oauth_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oauth_client` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `client_id` varchar(64) NOT NULL COMMENT '客户端ID',
  `client_secret` varchar(128) NOT NULL COMMENT '客户端密钥',
  `client_name` varchar(128) DEFAULT NULL COMMENT '应用名称',
  `redirect_uri` varchar(512) NOT NULL COMMENT '回调地址',
  `grant_types` varchar(128) NOT NULL DEFAULT 'authorization_code' COMMENT '授权类型',
  `scope` varchar(128) NOT NULL DEFAULT 'openid profile' COMMENT '授权范围',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0停用，1启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_client_id` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OAuth2/OIDC 客户端';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_oauth_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oauth_code` (
  `code` varchar(64) NOT NULL COMMENT '授权码',
  `client_id` varchar(64) NOT NULL COMMENT '客户端ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `redirect_uri` varchar(512) DEFAULT NULL COMMENT '回调地址',
  `scope` varchar(128) DEFAULT NULL COMMENT '授权范围',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `used` tinyint NOT NULL DEFAULT '0' COMMENT '是否已使用：0否，1是',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OAuth2 授权码(用后即焚)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_outbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_outbox` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `event_type` varchar(64) NOT NULL COMMENT 'SUBSCRIPTION_ACTIVATED/RENEWED/UPGRADED/DOWNGRADED/CANCELED/EXPIRED/BILL_GENERATED',
  `aggregate_type` varchar(32) NOT NULL DEFAULT 'SUBSCRIPTION',
  `aggregate_id` bigint NOT NULL COMMENT '聚合根编号(订阅id)',
  `payload` text COMMENT '事件负载JSON',
  `status` varchar(16) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/PROCESSING/DONE/FAILED',
  `retry_times` int NOT NULL DEFAULT '0',
  `max_retries` int NOT NULL DEFAULT '5',
  `next_retry_time` datetime DEFAULT NULL,
  `idempotency_key` varchar(128) DEFAULT NULL COMMENT 'aggregateType:aggregateId:eventType:yyyy-MM-dd',
  `last_error` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `done_time` datetime DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行更新时间(僵尸复位依据)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_outbox_idem` (`idempotency_key`),
  KEY `idx_outbox_status_time` (`status`,`next_retry_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Outbox事件';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_package_global`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_package_global` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '套餐编号',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '套餐名称',
  `price` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT '套餐价格',
  `valid_days` int NOT NULL DEFAULT '30' COMMENT '套餐有效天数',
  `daily_limit` int NOT NULL DEFAULT '0' COMMENT '每日调用上限，0表示无限调用',
  `qps_limit` int NOT NULL DEFAULT '0' COMMENT '每秒调用QPS上限，0表示不限制',
  `is_recommended` tinyint NOT NULL DEFAULT '0' COMMENT '推荐展示(最受欢迎)',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_package_global_status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='全站套餐表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_package_interface`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_package_interface` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '接口套餐编号',
  `interface_id` bigint NOT NULL COMMENT '接口编号',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '套餐名称',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_package_interface_api` (`interface_id`) USING BTREE,
  KEY `idx_package_interface_status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=311 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='接口套餐表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_package_interface_spec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_package_interface_spec` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '套餐规格编号',
  `package_id` bigint NOT NULL COMMENT '接口套餐编号',
  `spec_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规格名称',
  `price` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT '规格价格',
  `valid_days` int NOT NULL DEFAULT '30' COMMENT '规格有效天数',
  `daily_limit` int NOT NULL DEFAULT '0' COMMENT '每日调用上限，0表示无限调用',
  `qps_limit` int NOT NULL DEFAULT '0' COMMENT '每秒调用QPS上限，0表示不限制',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_package_interface_spec_package` (`package_id`) USING BTREE,
  KEY `idx_package_interface_spec_status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='接口套餐规格表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_package_point`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_package_point` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '点数套餐编号',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '套餐名称',
  `price` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT '套餐价格',
  `point_amount` bigint NOT NULL DEFAULT '0' COMMENT '套餐点数',
  `is_recommended` tinyint NOT NULL DEFAULT '0' COMMENT '推荐展示(超值)',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_package_point_status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='点数套餐表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_package_price_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_package_price_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_type` varchar(32) NOT NULL DEFAULT 'SUBSCRIPTION_PLAN' COMMENT '商品类型 GLOBAL_PACKAGE/INTERFACE_PACKAGE/POINT_PACKAGE/SUBSCRIPTION_PLAN',
  `product_id` bigint NOT NULL COMMENT '商品编号（按 product_type 对应各商品表主键）',
  `rule_type` varchar(32) NOT NULL DEFAULT 'QUANTITY' COMMENT 'QUANTITY按量/MEMBER_LEVEL按会员等级/TIME按时段',
  `priority` int NOT NULL DEFAULT '0' COMMENT '优先级,数值越大越优先',
  `min_quantity` int NOT NULL DEFAULT '0' COMMENT '最低数量(含)',
  `max_quantity` int NOT NULL DEFAULT '0' COMMENT '最高数量(含),0=不限',
  `member_level` varchar(32) DEFAULT NULL COMMENT '会员等级(匹配规则),',
  `discount_ratio` decimal(5,4) NOT NULL DEFAULT '1.0000' COMMENT '折扣比例(1.0=原价,0.8=8折)',
  `price_override` decimal(12,4) DEFAULT NULL COMMENT '直接覆盖价格(null=不覆盖,走折扣)',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1启用/0禁用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_price_rule_plan` (`product_id`,`status`,`priority`),
  KEY `idx_rule_product` (`product_type`,`product_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='套餐阶梯定价规则';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_password_policy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_password_policy` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，固定为1',
  `min_length` int NOT NULL DEFAULT '8' COMMENT '密码最小长度',
  `require_upper` tinyint NOT NULL DEFAULT '1' COMMENT '必须包含大写字母：0否，1是',
  `require_lower` tinyint NOT NULL DEFAULT '1' COMMENT '必须包含小写字母：0否，1是',
  `require_digit` tinyint NOT NULL DEFAULT '1' COMMENT '必须包含数字：0否，1是',
  `require_special` tinyint NOT NULL DEFAULT '0' COMMENT '必须包含特殊字符：0否，1是',
  `no_repeat` tinyint NOT NULL DEFAULT '0' COMMENT '禁止3位及以上连续重复字符：0否，1是',
  `expire_days` int NOT NULL DEFAULT '0' COMMENT '密码有效期天数，0表示永不过期',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='密码复杂度策略';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_payment_alipay_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_payment_alipay_config` (
  `id` tinyint NOT NULL COMMENT '配置编号',
  `enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否启用支付宝：1启用，0禁用',
  `app_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '支付宝开放平台应用ID',
  `gateway_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'https://openapi.alipay.com/gateway.do' COMMENT '支付宝网关地址',
  `merchant_private_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '应用私钥',
  `alipay_public_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '支付宝公钥',
  `notify_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '异步通知地址',
  `return_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '同步跳转地址',
  `website_pay_enabled` tinyint NOT NULL DEFAULT '1' COMMENT '是否启用电脑网站支付：1启用，0禁用',
  `wap_pay_enabled` tinyint NOT NULL DEFAULT '1' COMMENT '是否启用手机网站支付：1启用，0禁用',
  `face_pay_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否启用当面付扫码支付：1启用，0禁用',
  `sign_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'RSA2' COMMENT '签名方式',
  `charset_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'UTF-8' COMMENT '字符集',
  `format_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'JSON' COMMENT '响应格式',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='支付宝支付配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_payment_channel_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_payment_channel_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `channel_code` varchar(32) NOT NULL COMMENT '通道编码：QQPAY/UNIONPAY/JDPAY/PAYPAL/STRIPE/FUIYOU/XPAY',
  `channel_name` varchar(64) NOT NULL COMMENT '通道名称',
  `config_json` text COMMENT '通道配置JSON(网关/商户ID/密钥等)',
  `enabled` tinyint NOT NULL DEFAULT '0' COMMENT '1启用/0停用',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_channel_code` (`channel_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1850 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通用支付通道配置';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_payment_merchant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_payment_merchant` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `channel` varchar(32) NOT NULL COMMENT '支付渠道：ALIPAY/WECHAT/QQPAY/UNIONPAY 等',
  `tenant_code` varchar(64) NOT NULL DEFAULT 'default' COMMENT '租户编码，default 为默认商户',
  `merchant_name` varchar(128) NOT NULL DEFAULT '' COMMENT '商户名称',
  `config_json` text COMMENT '渠道配置 JSON（appId/mchId/key/notifyUrl 等）',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用 0停用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_payment_merchant_channel_tenant` (`channel`,`tenant_code`),
  KEY `idx_payment_merchant_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='多商户支付配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_payment_notify_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_payment_notify_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `order_no` varchar(64) DEFAULT NULL COMMENT '订单号',
  `channel` varchar(16) NOT NULL COMMENT '渠道：ALIPAY支付宝，WECHAT微信',
  `notify_type` varchar(16) NOT NULL COMMENT '类型：CALLBACK渠道回调，ACTIVE_QUERY主动查单',
  `verify_result` varchar(16) NOT NULL COMMENT '验签结果：PASS通过，FAIL失败，SKIP跳过',
  `process_result` varchar(16) NOT NULL COMMENT '处理结果：SUCCESS成功，FAILED失败，IGNORED忽略',
  `error_msg` varchar(512) DEFAULT NULL COMMENT '失败原因',
  `payload` mediumtext COMMENT '通知或查询原始报文',
  `process_time_ms` bigint DEFAULT NULL COMMENT '处理耗时毫秒',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_notify_log_order` (`order_no`),
  KEY `idx_notify_log_channel` (`channel`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='支付通知日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_payment_order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_payment_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(64) NOT NULL COMMENT '关联 sys_payment_recharge_order.order_no',
  `item_index` int NOT NULL DEFAULT '0' COMMENT '行序号(从0开始)',
  `biz_type` varchar(32) NOT NULL COMMENT 'GLOBAL_PACKAGE/INTERFACE_PACKAGE/POINT_PACKAGE/SUBSCRIPTION',
  `biz_id` bigint NOT NULL COMMENT '业务编号(套餐id/订阅id)',
  `biz_name` varchar(128) NOT NULL COMMENT '业务名称快照',
  `amount` decimal(12,4) NOT NULL COMMENT '行金额',
  `entitlement_snapshot` mediumtext COMMENT '该行权益快照JSON',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_item` (`order_no`,`item_index`),
  KEY `idx_order_item_biz` (`biz_type`,`biz_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单明细行(一单多品)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_payment_recharge_amount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_payment_recharge_amount` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '充值金额配置编号',
  `amount` decimal(12,4) NOT NULL COMMENT '充值支付金额',
  `gift_amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '赠送金额',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_payment_recharge_amount` (`amount`) USING BTREE,
  KEY `idx_payment_recharge_amount_status_sort` (`status`,`sort_no`,`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='充值金额配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_payment_recharge_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_payment_recharge_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '充值订单编号',
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商户订单号',
  `user_id` bigint NOT NULL COMMENT '充值用户编号',
  `order_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'RECHARGE' COMMENT '订单类型',
  `biz_id` bigint DEFAULT NULL COMMENT '业务编号',
  `biz_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务名称',
  `amount` decimal(12,4) NOT NULL COMMENT '充值金额',
  `refund_amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '累计退款金额',
  `gift_amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '充值赠送金额',
  `discount_price` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '优惠金额',
  `point_price` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '点数抵扣折算金额',
  `pay_price` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '实付金额=amount-discount_price-point_price',
  `pay_channel` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ALIPAY' COMMENT '支付渠道：ALIPAY支付宝、WECHAT微信、BALANCE余额',
  `pay_product` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '支付产品：PAGE电脑网站、WAP手机网站、FACE当面付、NATIVE微信扫码',
  `alipay_method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '第三方接口方法',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING' COMMENT '订单状态：PENDING待支付、PAID已支付、FAILED失败、CLOSED关闭',
  `subject` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单标题',
  `body` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单描述',
  `entitlement_snapshot` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '套餐权益快照JSON',
  `trade_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '第三方交易号',
  `share_key` varchar(32) DEFAULT NULL COMMENT '分享密钥(免登录查看)',
  `buyer_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '第三方买家用户标识',
  `qr_code` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '扫码支付二维码内容',
  `client_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AUTO' COMMENT '客户端类型：AUTO、DESKTOP、MOBILE',
  `notify_payload` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '第三方支付通知原始参数',
  `paid_time` datetime DEFAULT NULL COMMENT '支付完成时间',
  `expire_time` datetime NOT NULL COMMENT '订单过期时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `payment_state` varchar(8) DEFAULT NULL COMMENT '支付状态码',
  `state_reason` varchar(8) DEFAULT NULL COMMENT '状态原因',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_recharge_order_no` (`order_no`) USING BTREE,
  UNIQUE KEY `uk_recharge_share_key` (`share_key`),
  KEY `idx_recharge_user` (`user_id`) USING BTREE,
  KEY `idx_recharge_order_type` (`order_type`) USING BTREE,
  KEY `idx_recharge_status` (`status`) USING BTREE,
  KEY `idx_recharge_status_expire_time` (`status`,`expire_time`) USING BTREE,
  KEY `idx_recharge_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='账户余额充值订单表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_payment_refund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_payment_refund` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '退款单编号',
  `refund_no` varchar(64) NOT NULL COMMENT '商户退款单号',
  `order_no` varchar(64) NOT NULL COMMENT '原支付订单号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `amount` decimal(12,4) NOT NULL COMMENT '退款金额',
  `reason` varchar(255) DEFAULT NULL COMMENT '退款原因',
  `channel` varchar(32) NOT NULL COMMENT '支付渠道：ALIPAY支付宝，WECHAT微信',
  `channel_refund_no` varchar(128) DEFAULT NULL COMMENT '渠道退款单号',
  `status` varchar(16) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING处理中，SUCCESS成功，FAILED失败，MANUAL转人工介入（渠道查单连续失败，未回补余额）',
  `channel_error` varchar(512) DEFAULT NULL COMMENT '渠道返回错误',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人编号',
  `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人名称',
  `refund_time` datetime DEFAULT NULL COMMENT '退款成功时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_refund_no` (`refund_no`),
  KEY `idx_refund_order` (`order_no`),
  KEY `idx_refund_user` (`user_id`),
  KEY `idx_refund_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='支付退款单表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_payment_retry_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_payment_retry_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务编号',
  `order_no` varchar(64) NOT NULL COMMENT '订单号',
  `channel` varchar(16) NOT NULL COMMENT '渠道：ALIPAY支付宝，WECHAT微信',
  `retry_times` int NOT NULL DEFAULT '0' COMMENT '已重试次数',
  `max_retry_times` int NOT NULL DEFAULT '10' COMMENT '最大重试次数',
  `next_retry_time` datetime NOT NULL COMMENT '下次重试时间',
  `status` varchar(16) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING待重试，DONE已完成，FAILED超过重试上限，CANCELED订单已关闭',
  `last_error` varchar(512) DEFAULT NULL COMMENT '最近失败原因',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_retry_task_status` (`status`,`next_retry_time`),
  KEY `idx_retry_task_order` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='支付对账重试任务表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_payment_wechat_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_payment_wechat_config` (
  `id` tinyint NOT NULL COMMENT '配置编号',
  `enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否启用微信支付：1启用，0禁用',
  `merchant_mode` varchar(16) NOT NULL DEFAULT 'NORMAL' COMMENT '商户模式：NORMAL普通商户/PARTNER服务商',
  `sp_app_id` varchar(64) DEFAULT NULL COMMENT '服务商AppID',
  `sub_app_id` varchar(64) DEFAULT NULL COMMENT '子商户AppID',
  `sub_mch_id` varchar(64) DEFAULT NULL COMMENT '子商户号',
  `app_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '微信支付绑定的AppID',
  `mch_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '微信支付商户号',
  `api_v3_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '微信支付APIv3密钥',
  `merchant_serial_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商户API证书序列号',
  `merchant_private_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '商户API证书私钥',
  `wechatpay_public_key_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '微信支付平台公钥ID或平台证书序列号',
  `wechatpay_public_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '微信支付平台公钥，用于回调验签',
  `notify_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '异步通知地址',
  `native_pay_enabled` tinyint NOT NULL DEFAULT '1' COMMENT '是否启用Native扫码支付：1启用，0禁用',
  `gateway_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'https://api.mch.weixin.qq.com' COMMENT '微信支付API网关地址',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='微信支付配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_plugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_plugin` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) NOT NULL COMMENT '插件名(plugin.yaml metadata.name)',
  `version` varchar(32) NOT NULL COMMENT '插件版本',
  `jar_path` varchar(512) NOT NULL COMMENT '插件 jar 路径',
  `phase` varchar(16) NOT NULL DEFAULT 'PENDING' COMMENT '运行阶段：PENDING/STARTED/STOPPED/FAILED',
  `enabled` tinyint NOT NULL DEFAULT '0' COMMENT '期望状态：1启用 0停用',
  `error_msg` varchar(500) DEFAULT NULL COMMENT '最近一次启停失败原因',
  `permissions_json` text COMMENT '插件声明权限 JSON',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `display_name` varchar(128) DEFAULT NULL COMMENT '插件展示名(plugin.yaml metadata.displayName)',
  `description` varchar(500) DEFAULT NULL COMMENT '插件描述',
  `author` varchar(128) DEFAULT NULL COMMENT '插件作者',
  `plugin_class` varchar(255) DEFAULT NULL COMMENT '插件主类',
  `requires_version` varchar(64) DEFAULT NULL COMMENT '声明的最低宿主版本 spec.requires',
  `host_version` varchar(32) DEFAULT NULL COMMENT '校验时的宿主版本',
  `digest` varchar(80) DEFAULT NULL COMMENT 'jar SHA-256 摘要(安装期计算)',
  `frontend_json` text COMMENT '前端资源声明 scripts/styles',
  `risk_json` text COMMENT '安装期静态扫描风险与体积',
  `skipped_json` text COMMENT '失败隔离跳过的可选扩展点',
  `extensions_json` text COMMENT '已注册扩展点快照',
  `health` varchar(16) DEFAULT NULL COMMENT '健康状态 UP/DOWN/NOT_SUPPORTED/UNKNOWN',
  `health_msg` varchar(500) DEFAULT NULL COMMENT '健康探针消息',
  `health_time` datetime DEFAULT NULL COMMENT '健康检查时间',
  `started_at` datetime DEFAULT NULL COMMENT '最近启动时刻',
  `start_ms` int DEFAULT NULL COMMENT '最近启动耗时(ms)',
  `invoke_count` bigint NOT NULL DEFAULT '0' COMMENT '扩展点调用计数',
  `last_invoke_time` datetime DEFAULT NULL COMMENT '最近调用时间',
  `error_count` int NOT NULL DEFAULT '0' COMMENT '累计失败次数',
  `last_error_time` datetime DEFAULT NULL COMMENT '最近失败时间',
  `source` varchar(32) NOT NULL DEFAULT 'UPLOAD' COMMENT '来源 UPLOAD/INDEXER/BUILTIN',
  `source_ref` varchar(512) DEFAULT NULL COMMENT '来源引用(索引URL或原始文件名)',
  `approved_by` bigint DEFAULT NULL COMMENT '最近审批操作人',
  `approved_at` datetime DEFAULT NULL COMMENT '最近审批时间',
  `approve_reason` varchar(500) DEFAULT NULL COMMENT '最近审批原因',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plugin_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='插件注册表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_plugin_approval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_plugin_approval` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plugin_name` varchar(64) NOT NULL COMMENT '插件名',
  `action` varchar(32) NOT NULL COMMENT '操作：install/upgrade/enable/disable/uninstall/config',
  `version` varchar(32) DEFAULT NULL COMMENT '操作时版本',
  `digest` varchar(80) DEFAULT NULL COMMENT '操作时 jar 摘要',
  `operator` bigint DEFAULT NULL COMMENT '操作人',
  `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人用户名',
  `reason` varchar(500) DEFAULT NULL COMMENT '管理员确认原因（信任模型 9.1）',
  `risk_json` text COMMENT '确认时的风险快照',
  `success` tinyint NOT NULL DEFAULT '1' COMMENT '是否成功',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_plugin_approval_name` (`plugin_name`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='插件审批留痕表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_plugin_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_plugin_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plugin_name` varchar(64) NOT NULL COMMENT '插件名',
  `setting_key` varchar(64) NOT NULL COMMENT '配置键',
  `setting_value` text COMMENT '配置值',
  `archived` tinyint NOT NULL DEFAULT '0' COMMENT '卸载归档(1=已归档,重装可恢复)',
  `archived_at` datetime DEFAULT NULL COMMENT '归档时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plugin_key` (`plugin_name`,`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='插件配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_plugin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_plugin_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plugin_name` varchar(64) DEFAULT NULL COMMENT '插件名',
  `action` varchar(32) DEFAULT NULL COMMENT '操作：install/enable/disable/uninstall',
  `operator` bigint DEFAULT NULL COMMENT '操作人用户 ID',
  `detail` varchar(1000) DEFAULT NULL COMMENT '操作详情',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `version` varchar(32) DEFAULT NULL COMMENT '操作时的插件版本',
  `risk_level` varchar(16) DEFAULT NULL COMMENT '风险级别 LOW/MEDIUM/HIGH',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='插件操作日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_point_exchange_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_point_exchange_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则编号',
  `package_type` varchar(32) NOT NULL COMMENT '套餐类型：GLOBAL_PACKAGE/INTERFACE_PACKAGE',
  `package_id` bigint NOT NULL COMMENT '套餐编号（对GLOBAL为sys_package_global.id，对INTERFACE为sys_package_interface.id）',
  `mix_spec_id` bigint DEFAULT NULL COMMENT '接口套餐的规格id（INTERFACE_PACKAGE 时必填）',
  `point_cost` bigint NOT NULL COMMENT '消耗点数',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1启用，0停用',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_exchange_rule_type` (`package_type`,`package_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='积分(点数)兑换套餐规则表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_point_movement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_point_movement` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `amount` decimal(12,4) NOT NULL,
  `type` varchar(24) NOT NULL,
  `ref_id` bigint DEFAULT NULL,
  `balance_after` decimal(12,4) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户点数变动表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_point_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_point_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `link_id` varchar(64) DEFAULT NULL COMMENT '关联单号；sign/system 为 0',
  `link_type` varchar(16) NOT NULL COMMENT '来源：order购买点数/consume积分兑换/sign签到/system后台',
  `type` tinyint NOT NULL COMMENT '1-增加，2-扣减',
  `title` varchar(64) NOT NULL COMMENT '标题',
  `point` bigint NOT NULL COMMENT '变动点数',
  `balance` bigint NOT NULL COMMENT '变动后点数',
  `mark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` tinyint NOT NULL DEFAULT '3' COMMENT '1-创建，3-完成，4-失效',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_point_record_user_time` (`user_id`,`create_time`),
  KEY `idx_point_record_link` (`link_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户点数(积分)流水表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_provider` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '服务商编号',
  `user_id` bigint NOT NULL COMMENT '申请用户编号，一人一行',
  `shop_name` varchar(64) NOT NULL COMMENT '店铺名称',
  `shop_code` varchar(64) DEFAULT NULL COMMENT '店铺编码',
  `avatar` varchar(1024) DEFAULT NULL COMMENT '店铺头像',
  `banner` varchar(1024) DEFAULT NULL COMMENT '店铺横幅图',
  `description` varchar(500) DEFAULT NULL COMMENT '店铺简介',
  `contact` varchar(128) NOT NULL COMMENT '联系方式',
  `commission_rate` decimal(5,4) NOT NULL DEFAULT '0.0000' COMMENT '平台抽成率，0到1之间',
  `settle_balance` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '可结算余额',
  `frozen_balance` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '提现冻结金额',
  `is_official` tinyint NOT NULL DEFAULT '0' COMMENT '是否官方服务商：1是，0否',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态：0待审核，1正常，2已驳回，3冻结',
  `apply_remark` varchar(500) DEFAULT NULL COMMENT '入驻申请理由',
  `audit_remark` varchar(500) DEFAULT NULL COMMENT '审核备注或驳回原因',
  `audit_admin_id` bigint DEFAULT NULL COMMENT '审核管理员编号',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_provider_user` (`user_id`),
  KEY `idx_sys_provider_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1024 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='服务商表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_provider_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_provider_category` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '分类编号',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '分类名称',
  `code` varchar(32) NOT NULL DEFAULT '' COMMENT '分类编码',
  `icon` varchar(255) DEFAULT NULL COMMENT '分类图标 URL',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序序号',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1 启用，0 禁用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0未删除 1已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='服务商分类表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_provider_category_rel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_provider_category_rel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` bigint NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_provider_category` (`provider_id`,`category_id`),
  KEY `fk_rel_category` (`category_id`),
  CONSTRAINT `fk_rel_category` FOREIGN KEY (`category_id`) REFERENCES `sys_provider_category` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rel_provider` FOREIGN KEY (`provider_id`) REFERENCES `sys_provider` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='服务商-分类关联表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_provider_settlement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_provider_settlement` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '结算记录编号',
  `provider_id` bigint NOT NULL COMMENT '服务商编号',
  `interface_id` bigint NOT NULL COMMENT '接口编号',
  `settle_date` date NOT NULL COMMENT '结算日期，自然日',
  `call_count` bigint NOT NULL DEFAULT '0' COMMENT '当日调用次数',
  `billable_count` bigint NOT NULL DEFAULT '0' COMMENT '当日计费次数',
  `gross_amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '当日流水金额',
  `commission_amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '平台抽成金额',
  `net_amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '服务商净收益',
  `cursor_log_id` bigint NOT NULL DEFAULT '0' COMMENT '结算游标，已结算到的最大调用日志编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_provider_settlement_day` (`provider_id`,`interface_id`,`settle_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='服务商结算账本表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_provider_settlement_reversal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_provider_settlement_reversal` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '冲销记录编号',
  `provider_id` bigint NOT NULL COMMENT '服务商编号',
  `interface_id` bigint NOT NULL COMMENT '接口编号',
  `reversal_date` date NOT NULL COMMENT '冲销日期',
  `call_count` bigint NOT NULL DEFAULT '0' COMMENT '冲销调用次数（负数表示扣减）',
  `amount` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '冲销金额（负数表示扣减）',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '冲销原因',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_reversal_provider_date` (`provider_id`,`reversal_date`),
  KEY `idx_reversal_date` (`reversal_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='服务商结算冲销明细表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_provider_statement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_provider_statement` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '对账单编号',
  `provider_id` bigint NOT NULL COMMENT '服务商编号',
  `statement_month` char(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '对账月份，格式 YYYY-MM',
  `call_count` bigint NOT NULL DEFAULT '0' COMMENT '当月调用总次数',
  `gross_amount` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '当月流水总金额',
  `commission_amount` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '平台抽成总金额',
  `net_amount` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '服务商净收益',
  `reversal_amount` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '冲销金额（次月对账扣减）',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（草稿、已确认）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_provider_month` (`provider_id`,`statement_month`),
  KEY `idx_statement_month` (`statement_month`),
  KEY `idx_statement_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='服务商月度对账单';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_provider_withdraw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_provider_withdraw` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '提现申请编号',
  `provider_id` bigint NOT NULL COMMENT '服务商编号',
  `amount` decimal(12,4) NOT NULL COMMENT '提现金额',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态：0待审核，1已打款，2已驳回',
  `reject_remark` varchar(500) DEFAULT NULL COMMENT '驳回原因',
  `operator_id` bigint DEFAULT NULL COMMENT '审核操作管理员编号',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_sys_provider_withdraw_provider_status` (`provider_id`,`status`),
  KEY `idx_sys_provider_withdraw_status_time` (`status`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='服务商提现申请表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_rate_limit_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_rate_limit_stat` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '统计编号',
  `dimension` varchar(16) NOT NULL COMMENT '限流维度: USER/IP/API_KEY/INTERFACE',
  `identifier` varchar(128) NOT NULL COMMENT '维度标识值',
  `interface_id` bigint NOT NULL DEFAULT '0' COMMENT '接口编号，0表示不限接口',
  `limit_type` varchar(32) NOT NULL COMMENT '限流类型: QPS/DAILY/CONCURRENCY/TOKEN_BUCKET',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `reject_count` int NOT NULL DEFAULT '0' COMMENT '拒绝次数',
  `pass_count` int NOT NULL DEFAULT '0' COMMENT '放行次数',
  `last_reject_time` datetime DEFAULT NULL COMMENT '最近拒绝时间',
  `last_pass_time` datetime DEFAULT NULL COMMENT '最近放行时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_rate_limit_stat_dim` (`dimension`,`identifier`,`interface_id`,`limit_type`,`stat_date`),
  KEY `idx_rate_limit_stat_date` (`stat_date`),
  KEY `idx_rate_limit_stat_interface` (`interface_id`,`stat_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='限流统计表(标准化)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_redeem_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_redeem_card` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '卡密编号',
  `batch_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '生成批次号',
  `card_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '卡密明文',
  `card_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '卡密类型：BALANCE余额、GLOBAL_PACKAGE全站套餐、INTERFACE_PACKAGE接口套餐、POINT_PACKAGE点数套餐',
  `amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '余额卡密金额',
  `point_amount` bigint NOT NULL DEFAULT '0' COMMENT '点数套餐到账点数',
  `package_scope` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '套餐范围：GLOBAL全站、INTERFACE接口、POINT点数',
  `package_id` bigint DEFAULT NULL COMMENT '套餐编号',
  `spec_id` bigint DEFAULT NULL COMMENT '接口套餐规格编号',
  `package_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '套餐展示名称',
  `reward_valid_days` int NOT NULL DEFAULT '0' COMMENT '套餐有效天数快照，生成卡密时写入',
  `entitlement_snapshot` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '套餐权益快照JSON',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `used` tinyint NOT NULL DEFAULT '0' COMMENT '是否已使用：1已使用，0未使用',
  `used_user_id` bigint DEFAULT NULL COMMENT '使用用户编号',
  `used_time` datetime DEFAULT NULL COMMENT '使用时间',
  `target_user_id` bigint DEFAULT NULL COMMENT '指定可兑换用户编号，空表示不限制',
  `target_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '指定可兑换用户账号',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间，空表示不过期',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `redeem_limit` int NOT NULL DEFAULT '1' COMMENT '可兑换次数',
  `redeemed_count` int NOT NULL DEFAULT '0' COMMENT '已兑换次数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_sys_redeem_card_code` (`card_code`) USING BTREE,
  KEY `idx_sys_redeem_card_batch` (`batch_no`) USING BTREE,
  KEY `idx_sys_redeem_card_type_used` (`card_type`,`used`,`status`) USING BTREE,
  KEY `idx_sys_redeem_card_used_user_time` (`used_user_id`,`used_time`) USING BTREE,
  KEY `idx_sys_redeem_card_target_user` (`target_user_id`,`used`,`status`) USING BTREE,
  KEY `idx_sys_redeem_card_creator_time` (`creator_id`,`create_time`) USING BTREE,
  KEY `idx_sys_redeem_card_expire` (`expire_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='卡密表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_redeem_card_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_redeem_card_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `card_id` bigint NOT NULL COMMENT '卡密编号',
  `card_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '卡密明文',
  `card_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '卡密类型',
  `reward_summary` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '兑换奖励摘要',
  `user_id` bigint NOT NULL COMMENT '使用用户编号',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '使用用户账号',
  `real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '使用用户姓名',
  `client_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '兑换来源IP',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '兑换时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sys_redeem_card_log_card` (`card_id`) USING BTREE,
  KEY `idx_sys_redeem_card_log_user_time` (`user_id`,`create_time`) USING BTREE,
  KEY `idx_sys_redeem_card_log_type_time` (`card_type`,`create_time`) USING BTREE,
  KEY `idx_sys_redeem_card_log_code` (`card_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='卡密兑换日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_redeem_card_open_key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_redeem_card_open_key` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公开接口Key编号',
  `key_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Key名称',
  `km_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公开接口调用Key',
  `card_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公开类型：GLOBAL、INTERFACE、POINT、BALANCE',
  `type_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型编码：global、interface、point、balance',
  `amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '兼容保留字段，余额金额以公开接口money参数为准',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人编号',
  `last_used_time` datetime DEFAULT NULL COMMENT '最后调用时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `total_quota` bigint NOT NULL DEFAULT '0' COMMENT '累计开卡上限,0=不限',
  `used_count` bigint NOT NULL DEFAULT '0' COMMENT '累计已开卡数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_sys_redeem_card_open_key` (`km_key`) USING BTREE,
  KEY `idx_sys_redeem_card_open_key_type_status` (`card_type`,`status`) USING BTREE,
  KEY `idx_sys_redeem_card_open_key_creator` (`creator_id`,`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='卡密公开接口Key表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_referral_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_referral_code` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '邀请码编号',
  `user_id` bigint NOT NULL COMMENT '所属用户编号',
  `code` varchar(16) NOT NULL COMMENT '邀请码',
  `invite_count` int NOT NULL DEFAULT '0' COMMENT '邀请人数',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0停用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_referral_code_code` (`code`),
  UNIQUE KEY `uk_sys_referral_code_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='推介邀请码表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_referral_commission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_referral_commission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '佣金 ID',
  `referrer_id` bigint NOT NULL COMMENT '推荐人 ID',
  `referee_id` bigint NOT NULL COMMENT '被推荐人 ID',
  `call_log_id` bigint NOT NULL,
  `interface_id` bigint NOT NULL,
  `charge_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `rate` decimal(5,4) NOT NULL DEFAULT '0.0000',
  `config_id` bigint DEFAULT NULL COMMENT '配置 ID',
  `brokerage_level` tinyint NOT NULL DEFAULT '1' COMMENT '返佣级数：1=一级推荐人，2=二级推荐人',
  `ancestor_id` bigint DEFAULT NULL COMMENT '该级佣金实际归属人编号，与 referrer_id 一致',
  `amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '佣金金额',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0冻结中，1可结算，3已结算，4已冲销',
  `settle_time` datetime DEFAULT NULL COMMENT '结算时间',
  `unfreeze_time` datetime DEFAULT NULL COMMENT '预计解冻时间，冻结中状态使用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_call_log_level` (`call_log_id`,`brokerage_level`),
  KEY `idx_referrer_status` (`referrer_id`,`status`),
  KEY `idx_settle_time` (`settle_time`),
  KEY `idx_sys_referral_commission_unfreeze` (`status`,`unfreeze_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='推介佣金记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_referral_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_referral_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Config ID',
  `scope_type` varchar(16) NOT NULL COMMENT '作用范围',
  `target_id` bigint NOT NULL DEFAULT '0' COMMENT 'Target ID',
  `rate` decimal(5,4) NOT NULL DEFAULT '0.0000',
  `rate_two` decimal(6,4) DEFAULT NULL COMMENT '二级返佣比例，NULL=不启用二级',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT 'Status: 1=enabled',
  `updated_by` bigint DEFAULT NULL COMMENT '最后更新人编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_scope_target` (`scope_type`,`target_id`),
  KEY `idx_config_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='推介分佣配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_referral_config_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_referral_config_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `config_id` bigint NOT NULL COMMENT '配置编号',
  `old_rate` decimal(5,4) DEFAULT NULL COMMENT '变更前比例',
  `new_rate` decimal(5,4) NOT NULL COMMENT '变更后比例',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人编号',
  `remark` varchar(500) DEFAULT NULL COMMENT '操作备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_sys_referral_config_log_config` (`config_id`),
  KEY `idx_sys_referral_config_log_operator` (`operator_id`)
) ENGINE=InnoDB AUTO_INCREMENT=243 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='推介分佣配置审计日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_referral_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_referral_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关系 ID',
  `referrer_id` bigint NOT NULL COMMENT '推荐人 ID',
  `referee_id` bigint NOT NULL COMMENT '被推荐人 ID',
  `referral_code` varchar(16) NOT NULL DEFAULT '' COMMENT '邀请码',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态: 1=有效',
  `bind_mode` varchar(16) NOT NULL DEFAULT 'ANYTIME' COMMENT '绑定模式：ANYTIME=任意绑定，REGISTER=仅注册绑定，OVERRIDE=新邀请可覆盖',
  `audit_status` tinyint NOT NULL DEFAULT '1' COMMENT '审核状态：1=有效，0=待审核（审核流程暂未启用）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_referee` (`referee_id`),
  KEY `idx_referrer` (`referrer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='推介关系表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_referral_withdraw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_referral_withdraw` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '提现记录编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '提现金额',
  `account_type` varchar(32) NOT NULL COMMENT '账户类型：ALIPAY支付宝，BANK银行卡等',
  `account_no` varchar(128) NOT NULL COMMENT '收款账号',
  `account_name` varchar(64) NOT NULL COMMENT '收款人姓名',
  `fee_amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '手续费',
  `final_amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '实发金额',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态：0待审核，1待打款，2已驳回，3已打款，4打款失败已返还',
  `reject_reason` varchar(500) DEFAULT NULL COMMENT '驳回原因',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `audit_by` bigint DEFAULT NULL COMMENT '审核人编号',
  `pay_time` datetime DEFAULT NULL COMMENT '打款完成时间',
  `pay_operator_id` bigint DEFAULT NULL COMMENT '打款操作人编号',
  `pay_fail_reason` varchar(500) DEFAULT NULL COMMENT '打款失败原因',
  `apply_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_sys_referral_withdraw_user_status` (`user_id`,`status`),
  KEY `idx_sys_referral_withdraw_status_apply` (`status`,`apply_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='推介佣金提现记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_referral_withdraw_transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_referral_withdraw_transfer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '转账单编号',
  `withdraw_id` bigint NOT NULL COMMENT '关联 sys_referral_withdraw.id',
  `user_id` bigint NOT NULL COMMENT '收款用户',
  `transfer_no` varchar(32) NOT NULL COMMENT '平台转账单号(内部唯一)',
  `biz_transfer_no` varchar(100) NOT NULL COMMENT '商户转账号(幂等键, 重试复用)',
  `channel_code` varchar(32) NOT NULL COMMENT '打款渠道编码(如 alipay/wechat/manual)',
  `channel_mch_no` varchar(64) DEFAULT NULL COMMENT '通道商户号(路由确定后写入)',
  `out_transfer_no` varchar(150) DEFAULT NULL COMMENT '通道返回的转账单号(对账回查)',
  `amount` decimal(12,4) NOT NULL COMMENT '实发金额=final_amount(与业务单一致)',
  `currency` varchar(8) NOT NULL DEFAULT 'CNY' COMMENT '币种',
  `status` varchar(32) NOT NULL DEFAULT 'init' COMMENT '状态：init初始化，processing处理中，success成功，fail失败，close已关闭',
  `payee_type` varchar(20) NOT NULL COMMENT '收款人类型：ALIPAY/WECHAT/BANK_CARD',
  `payee_account` varchar(100) NOT NULL COMMENT '收款账号(敏感)',
  `payee_name` varchar(200) DEFAULT NULL COMMENT '收款人姓名(敏感)',
  `error_msg` varchar(2048) DEFAULT NULL COMMENT '失败原因',
  `finish_time` datetime DEFAULT NULL COMMENT '终态时间',
  `notify_time` datetime DEFAULT NULL COMMENT '通道回调到账时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_withdraw` (`withdraw_id`),
  UNIQUE KEY `uk_transfer_no` (`transfer_no`),
  UNIQUE KEY `uk_biz_transfer_no` (`biz_transfer_no`),
  KEY `idx_user_status` (`user_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='佣金提现转账单(资金凭证, 业务态在 sys_referral_withdraw)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_register_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_register_config` (
  `id` tinyint NOT NULL COMMENT '配置编号',
  `register_enabled` tinyint NOT NULL DEFAULT '1' COMMENT '是否开放注册：1开放，0关闭',
  `default_user_qps` int NOT NULL DEFAULT '1' COMMENT '普通用户默认QPS上限',
  `register_gift_points` bigint NOT NULL DEFAULT '0' COMMENT '注册赠送点数',
  `verification_code_ip_minute_limit` int NOT NULL DEFAULT '5' COMMENT '验证码发送IP每分钟上限，0表示不限制',
  `verification_code_ip_hour_limit` int NOT NULL DEFAULT '20' COMMENT '验证码发送IP每小时上限，0表示不限制',
  `verification_code_ip_day_limit` int NOT NULL DEFAULT '50' COMMENT '验证码发送IP每日上限，0表示不限制',
  `register_ip_hour_limit` int NOT NULL DEFAULT '10' COMMENT '注册提交IP每小时上限，0表示不限制',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='注册总开关配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_register_email_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_register_email_code` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '验证码编号',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邮箱',
  `code_hash` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '验证码哈希',
  `scene` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'register' COMMENT '验证码场景',
  `used` tinyint NOT NULL DEFAULT '0' COMMENT '是否已使用：1是，0否',
  `fail_count` int NOT NULL DEFAULT '0' COMMENT '失败次数',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `used_time` datetime DEFAULT NULL COMMENT '使用时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_register_email_code_email_scene` (`email`,`scene`) USING BTREE,
  KEY `idx_register_email_code_expire_time` (`expire_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='注册邮箱验证码表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_register_email_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_register_email_config` (
  `id` tinyint NOT NULL COMMENT '配置编号',
  `enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否启用邮箱注册：1启用，0禁用',
  `smtp_server` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'SMTP服务器',
  `smtp_port` int DEFAULT NULL COMMENT 'SMTP端口',
  `sender_email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发件邮箱',
  `auth_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱授权码',
  `sender_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发件人名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='邮箱注册配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_register_mobile_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_register_mobile_code` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '验证码编号',
  `mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机号',
  `code_hash` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '验证码哈希',
  `scene` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'register' COMMENT '验证码场景',
  `used` tinyint NOT NULL DEFAULT '0' COMMENT '是否已使用：1是，0否',
  `fail_count` int NOT NULL DEFAULT '0' COMMENT '失败次数',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `used_time` datetime DEFAULT NULL COMMENT '使用时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_register_mobile_code_mobile_scene` (`mobile`,`scene`) USING BTREE,
  KEY `idx_register_mobile_code_expire_time` (`expire_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='注册手机验证码表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_register_mobile_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_register_mobile_config` (
  `id` tinyint NOT NULL COMMENT '配置编号',
  `enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否启用手机号注册：1启用，0禁用',
  `provider` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'aliyun' COMMENT '短信厂商：aliyun阿里云',
  `access_key_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'AccessKey ID',
  `access_key_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'AccessKey Secret',
  `sign_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '短信签名',
  `template_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '短信模板编号',
  `region` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '地域',
  `endpoint` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '接口端点',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='手机号注册配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_report_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_report_template` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '报表名称',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `dataset_id` bigint DEFAULT NULL COMMENT '关联数据集ID',
  `cells_json` text COMMENT '单元格配置JSON([{row,col,rowspan,colspan,value,style,formula}])',
  `status` int NOT NULL DEFAULT '1' COMMENT '1启用 0禁用',
  `creator_id` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_report_template_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='报表模板';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_resource` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '资源编号',
  `resource_name` varchar(64) NOT NULL COMMENT '资源名称',
  `resource_code` varchar(64) NOT NULL COMMENT '资源编码（操作级判断用）',
  `url_pattern` varchar(255) NOT NULL COMMENT 'URL 匹配模式（Ant 风格，去掉 /api 前缀后的路径）',
  `http_method` varchar(16) DEFAULT '' COMMENT '空=全部方法',
  `permission_type` varchar(16) NOT NULL DEFAULT 'URL' COMMENT 'URL/OPERATION',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0禁用，1启用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_resource_code` (`resource_code`),
  KEY `idx_url` (`url_pattern`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='权限资源表（三维权限模型：角色+资源+操作）';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色编号',
  `role_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色标识',
  `role_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `data_scope` tinyint NOT NULL DEFAULT '1' COMMENT '数据范围：1 全部数据，2 仅本人数据',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_sys_role_key` (`role_key`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统角色表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色编号',
  `menu_id` bigint NOT NULL COMMENT '菜单编号',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE,
  KEY `idx_sys_role_menu_menu` (`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='角色菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '绑定编号',
  `role_id` bigint NOT NULL COMMENT '角色编号',
  `resource_id` bigint NOT NULL COMMENT '资源编号',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '绑定时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_resource` (`role_id`,`resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色-资源权限绑定';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_schedule_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_schedule_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务编号',
  `task_name` varchar(100) NOT NULL COMMENT '任务名称',
  `task_group` varchar(64) NOT NULL DEFAULT 'DEFAULT' COMMENT '任务分组',
  `invoke_target` varchar(255) NOT NULL COMMENT '调用目标：beanName.methodName',
  `cron_expression` varchar(64) NOT NULL COMMENT 'cron 表达式',
  `misfire_policy` tinyint NOT NULL DEFAULT '1' COMMENT '错过执行策略：1 立即补执行 2 补执行一次 3 放弃',
  `concurrent` tinyint NOT NULL DEFAULT '0' COMMENT '是否允许并发：0 禁止 1 允许',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1 运行 0 暂停',
  `last_run_time` datetime DEFAULT NULL COMMENT '最近执行时间',
  `last_result` varchar(32) DEFAULT NULL COMMENT '最近执行结果：SUCCESS/FAILED/RUNNING',
  `last_cost_ms` bigint DEFAULT NULL COMMENT '最近执行耗时（毫秒）',
  `last_message` varchar(1000) DEFAULT NULL COMMENT '最近执行信息',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `retry_count` int NOT NULL DEFAULT '0',
  `max_retry` int NOT NULL DEFAULT '2',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_schedule_task_name` (`task_name`),
  KEY `idx_sys_schedule_task_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务定义（平台化调度）';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_schedule_task_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_schedule_task_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `task_id` bigint NOT NULL COMMENT '任务编号',
  `task_name` varchar(100) NOT NULL COMMENT '任务名称（冗余，便于任务删除后追溯）',
  `trigger_type` varchar(16) NOT NULL COMMENT '触发方式：AUTO 调度 / MANUAL 手动',
  `result` varchar(32) NOT NULL COMMENT '执行结果：SUCCESS/FAILED',
  `cost_ms` bigint DEFAULT NULL COMMENT '执行耗时（毫秒）',
  `message` varchar(1000) DEFAULT NULL COMMENT '执行信息或异常摘要',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '执行时间',
  PRIMARY KEY (`id`),
  KEY `idx_sys_schedule_task_log_task` (`task_id`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6395 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务执行日志';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_security_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_security_config` (
  `config_key` varchar(64) NOT NULL COMMENT '配置键',
  `config_value` varchar(1024) DEFAULT NULL COMMENT '配置值',
  `remark` varchar(255) DEFAULT NULL COMMENT '说明',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='安全统一配置(验证码/MFA模板/登录策略/第三方登录)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_settlement_reversal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_settlement_reversal` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '冲销 ID',
  `biz_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '业务类型: SETTLEMENT/COMMISSION',
  `biz_id` bigint NOT NULL COMMENT '业务 ID (结算明细 ID 或佣金 ID)',
  `call_log_id` bigint DEFAULT NULL COMMENT '关联调用日志 ID',
  `amount` decimal(12,4) NOT NULL COMMENT '冲销金额 (负向)',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '冲销原因',
  `operator_id` bigint NOT NULL COMMENT '鎿嶄綔浜?ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_biz` (`biz_type`,`biz_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='冲销记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_sign_in_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_sign_in_config` (
  `id` bigint NOT NULL COMMENT '主键（只有 1 条记录 id=1）',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用签到',
  `base_points` int NOT NULL DEFAULT '5' COMMENT '基础积分奖励',
  `base_exp` int NOT NULL DEFAULT '5' COMMENT '基础成长值奖励',
  `base_balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '基础余额奖励（元）',
  `continuous_rewards` text COMMENT '连续签到奖励 JSON：[{"days":7,"points":20,"exp":20,"balance":0}]',
  `makeup_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否允许补签',
  `makeup_points_cost` int NOT NULL DEFAULT '100' COMMENT '补签消耗积分',
  `makeup_days_limit` int NOT NULL DEFAULT '7' COMMENT '允许补签最近多少天内的日期',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `weekly_target_days` int NOT NULL DEFAULT '5',
  `freeze_enabled` tinyint NOT NULL DEFAULT '1',
  `freeze_cards_limit` int NOT NULL DEFAULT '3',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='签到配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_sign_in_day_reward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_sign_in_day_reward` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `day` int NOT NULL COMMENT '周期内第几天',
  `points` int NOT NULL DEFAULT '0' COMMENT '当日积分奖励',
  `exp` int NOT NULL DEFAULT '0' COMMENT '当日成长值奖励',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '当日余额奖励',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1 启用，0 停用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sign_day_reward_day` (`day`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='签到逐天奖励配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_site_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_site_config` (
  `id` tinyint NOT NULL COMMENT '配置编号，固定为1，全站仅一条站点配置',
  `site_name` varchar(64) NOT NULL DEFAULT '正贤Api' COMMENT '网站名称',
  `site_url` varchar(255) DEFAULT NULL COMMENT '站点域名（用于 SEO 推送与 canonical 前缀）',
  `logo_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '网站Logo地址',
  `slogan` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '网站标语',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '网站描述',
  `seo_keywords` varchar(255) DEFAULT NULL COMMENT '全站 SEO 关键词',
  `og_image` varchar(1024) DEFAULT NULL COMMENT '全站分享图地址',
  `seo_push_token` varchar(128) DEFAULT NULL COMMENT '搜索引擎推送 token（百度 data.zz.baidu.com）',
  `contact_email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系邮箱',
  `contact_phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `contact_qq` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系QQ',
  `contact_wechat` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系微信',
  `contact_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系地址',
  `icp` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备案信息',
  `copyright` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '版权信息',
  `nav_items` text COMMENT '顶部导航配置JSON，空使用默认',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `chk_sys_site_config_singleton` CHECK ((`id` = 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='站点单例配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_slow_sql_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_slow_sql_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sql_config_id` bigint DEFAULT NULL,
  `interface_id` bigint DEFAULT NULL,
  `datasource_id` bigint DEFAULT NULL,
  `sql_text` varchar(2000) DEFAULT NULL,
  `cost_ms` bigint NOT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='慢SQL记录';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_sql_api_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_sql_api_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `interface_id` bigint NOT NULL COMMENT '关联 sys_interface_api.id',
  `datasource_id` bigint NOT NULL COMMENT '关联 sys_sql_datasource.id',
  `sql_text` mediumtext NOT NULL COMMENT 'SELECT SQL，:name 占位符',
  `params_json` text COMMENT '[{name,type,required,defaultValue,example,desc}]',
  `result_type` varchar(16) NOT NULL DEFAULT 'LIST' COMMENT 'LIST 数组 / OBJECT 首行对象',
  `naming_strategy` varchar(16) NOT NULL DEFAULT 'NONE' COMMENT '响应列名策略 NONE/CAMEL_CASE/SNAKE_CASE/LOWER_CASE/UPPER_CASE',
  `date_format` varchar(32) DEFAULT NULL COMMENT '日期格式化 pattern, 如 yyyy-MM-dd HH:mm:ss; 留空不格式化',
  `decimal_scale` tinyint unsigned DEFAULT NULL COMMENT 'BigDecimal 序列化小数位; 留空不处理',
  `max_rows` int NOT NULL DEFAULT '500' COMMENT '单次返回行数上限',
  `timeout_ms` int NOT NULL DEFAULT '5000' COMMENT '执行超时',
  `qps_limit` int NOT NULL DEFAULT '0' COMMENT '接口级QPS上限（全部调用方合计），0不限流',
  `concurrency_limit` int NOT NULL DEFAULT '0' COMMENT '接口并发上限，0不限',
  `price_per_krows` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT '按量计费单价：元/千行，0不启用',
  `contract_json` mediumtext COMMENT '契约锁：发布时锁定的响应列[{name,type}]',
  `contract_locked` tinyint NOT NULL DEFAULT '0' COMMENT '契约锁开关：1锁定，漂移时拒绝执行',
  `page_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '分页开关：1开启，调用方传page/pageSize',
  `count_mode` varchar(12) NOT NULL DEFAULT 'OFF' COMMENT '分页总数模式 OFF/EXACT; EXACT 时响应头带 X-Total-Count',
  `canary_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '灰度发布开关',
  `canary_percent` int NOT NULL DEFAULT '0' COMMENT '灰度流量百分比0-100',
  `canary_json` mediumtext COMMENT '灰度配置JSON：datasource_id/sql_text/params_json等',
  `mock_enabled` tinyint NOT NULL DEFAULT '0' COMMENT 'Mock开关：1开启，直接返回mock_json',
  `mock_json` mediumtext COMMENT 'Mock响应体JSON',
  `fallback_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '降级开关：1开启，查询失败返回fallback_json',
  `fallback_json` mediumtext COMMENT '降级响应体JSON',
  `script_json` mediumtext COMMENT 'SpEL后处理脚本JSON：[{expression}]按序对每行求值',
  `dynamic_datasource_json` mediumtext COMMENT '动态数据源JSON：[{datasourceId,expression}]按序匹配首个为true的',
  `cache_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '响应缓存开关：1开启 0关闭',
  `cache_ttl_seconds` int NOT NULL DEFAULT '0' COMMENT '缓存秒数，0表示不缓存',
  `cache_key_expr` varchar(255) DEFAULT NULL COMMENT 'SpEL 缓存键表达式, 引用参数子集; 留空按全参数哈希',
  `field_mapping` text COMMENT '[{field,alias,mask}] 结果字段改名与脱敏规则',
  `field_whitelist` tinyint NOT NULL DEFAULT '0' COMMENT '列级白名单：1开启，未声明列不出站',
  `version` int NOT NULL DEFAULT '1' COMMENT '当前版本号，每次编辑保存+1',
  `draft_json` mediumtext COMMENT '未发布的草稿配置JSON',
  `draft_time` datetime DEFAULT NULL COMMENT '草稿保存时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `row_filter` text COMMENT 'A1 行级安全过滤规则JSON: [{column:user_id}]',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sql_cfg_interface` (`interface_id`),
  KEY `idx_sql_cfg_ds` (`datasource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SQL转API-接口SQL配置';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_sql_api_publish`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_sql_api_publish` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '申请编号',
  `interface_id` bigint NOT NULL COMMENT '关联 sys_interface_api.id',
  `applicant_id` bigint NOT NULL COMMENT '申请人 user_id（服务商）',
  `draft_snapshot_json` mediumtext NOT NULL COMMENT '提交时的草稿快照JSON（与线上 diff 前的原文）',
  `diff_json` mediumtext COMMENT '与线上配置的字段级对比结果JSON',
  `status` varchar(16) NOT NULL DEFAULT 'PENDING' COMMENT '审批状态：PENDING待审批/APPROVED已通过/REJECTED已驳回',
  `approver_id` bigint DEFAULT NULL COMMENT '审批人 user_id（管理员）',
  `opinion` varchar(500) DEFAULT NULL COMMENT '审批意见（驳回原因或通过备注）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '审批时间',
  PRIMARY KEY (`id`),
  KEY `idx_sql_publish_interface` (`interface_id`,`id`),
  KEY `idx_sql_publish_status` (`status`,`id`),
  KEY `idx_sql_publish_applicant` (`applicant_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SQL转API-发布审批申请（PENDING→APPROVED|REJECTED，APPROVED自动覆盖发布）';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_sql_api_runtime_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_sql_api_runtime_config` (
  `id` tinyint NOT NULL COMMENT '固定为1，全站仅一条',
  `default_max_rows` int NOT NULL DEFAULT '500' COMMENT '行数上限默认值（接口未单独配置时）',
  `max_rows_ceiling` int NOT NULL DEFAULT '5000' COMMENT '服务商可配置的行数上限封顶',
  `default_timeout_ms` int NOT NULL DEFAULT '5000' COMMENT '执行超时默认值',
  `max_timeout_ms` int NOT NULL DEFAULT '30000' COMMENT '执行超时封顶',
  `sql_text_max_length` int NOT NULL DEFAULT '8192' COMMENT 'SQL 文本长度上限',
  `param_max_count` int NOT NULL DEFAULT '100' COMMENT '参数个数上限',
  `param_value_max_length` int NOT NULL DEFAULT '10000' COMMENT '单参数值长度上限',
  `pool_max_size` int NOT NULL DEFAULT '4' COMMENT '每数据源连接池上限',
  `pool_connection_timeout_ms` int NOT NULL DEFAULT '3000' COMMENT '取连接超时',
  `pool_max_lifetime_min` int NOT NULL DEFAULT '30' COMMENT '连接最大存活(分钟)',
  `pool_total_guard` int NOT NULL DEFAULT '200' COMMENT '平台数据源池总数护栏',
  `debug_max_rows` int NOT NULL DEFAULT '200' COMMENT '在线调试行数上限',
  `debug_timeout_ms` int NOT NULL DEFAULT '5000' COMMENT '在线调试执行超时',
  `cache_ttl_max_seconds` int NOT NULL DEFAULT '3600' COMMENT '接口可配置的响应缓存TTL上限(秒)',
  `allow_intranet` tinyint NOT NULL DEFAULT '0' COMMENT '是否允许内网/本机地址作为数据源：1允许 0禁止',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SQL转API-运行时资源配置';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_sql_api_version_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_sql_api_version_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '历史记录编号',
  `interface_id` bigint NOT NULL COMMENT '关联 sys_interface_api.id',
  `version` int NOT NULL COMMENT '该快照对应的在线版本号',
  `operator_id` bigint NOT NULL COMMENT '触发保存/回退的操作人 user_id',
  `snapshot_json` mediumtext NOT NULL COMMENT '被覆盖前的完整配置快照',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '快照时间',
  PRIMARY KEY (`id`),
  KEY `idx_sql_ver_interface` (`interface_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SQL转API-版本历史快照';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_sql_datasource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_sql_datasource` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '数据源编号',
  `user_id` bigint NOT NULL COMMENT '所属服务商 user_id',
  `name` varchar(64) NOT NULL COMMENT '数据源名称',
  `db_type` varchar(16) NOT NULL DEFAULT 'MYSQL' COMMENT '数据库类型，一期固定 MYSQL',
  `host` varchar(255) NOT NULL COMMENT '主机地址',
  `port` int NOT NULL DEFAULT '3306' COMMENT '端口',
  `database_name` varchar(64) NOT NULL COMMENT '库名',
  `username` varchar(64) NOT NULL COMMENT '数据库账号',
  `password` varchar(512) NOT NULL COMMENT 'AES 加密后的密码',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0停用',
  `auto_disabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否由探活自动停用：1是，0否',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `health_status` varchar(16) NOT NULL DEFAULT 'UNKNOWN' COMMENT '探活状态 UNKNOWN/HEALTHY/UNHEALTHY',
  `last_probe_time` datetime DEFAULT NULL COMMENT '上次探活时间',
  `last_latency_ms` int DEFAULT NULL COMMENT '探活延迟(ms)',
  `probe_fail_count` int NOT NULL DEFAULT '0' COMMENT '连续探活失败次数',
  PRIMARY KEY (`id`),
  KEY `idx_sql_ds_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1382 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SQL转API-服务商数据源';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_sql_datasource_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_sql_datasource_metadata` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `datasource_id` bigint NOT NULL COMMENT '关联 sys_sql_datasource.id',
  `metadata_json` longtext COMMENT '库/表/字段元数据快照JSON',
  `synced_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最近采集时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ds_meta_datasource` (`datasource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SQL转API-数据源元数据缓存';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_system_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_system_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置编号',
  `config_key` varchar(128) NOT NULL COMMENT '配置键',
  `config_value` varchar(500) DEFAULT NULL COMMENT '配置值',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_system_config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_tenant` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '租户编号',
  `name` varchar(128) NOT NULL COMMENT '租户/组织名称',
  `owner_user_id` bigint NOT NULL COMMENT '负责人用户编号',
  `type` varchar(16) NOT NULL DEFAULT 'PERSONAL' COMMENT 'PERSONAL个人/ORGANIZATION组织',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1正常/0停用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_tenant_owner` (`owner_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户(组织/团队)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_tenant_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_tenant_bill` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint NOT NULL,
  `subscription_id` bigint NOT NULL,
  `billing_start` datetime NOT NULL,
  `billing_end` datetime NOT NULL,
  `total_calls` bigint NOT NULL DEFAULT '0' COMMENT '周期计费调用次数',
  `total_amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT 'METERED模式应计金额,PACKAGE/QUOTA模式为0',
  `paid_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `status` varchar(16) NOT NULL DEFAULT 'OPEN' COMMENT 'OPEN/PAID/OVERDUE',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_tenant_bill_tenant` (`tenant_id`,`billing_start`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户账单';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_tenant_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_tenant_member` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `role` varchar(16) NOT NULL DEFAULT 'MEMBER' COMMENT 'OWNER/ADMIN/MEMBER',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1有效/0移除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_member` (`tenant_id`,`user_id`),
  KEY `idx_tenant_member_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户成员';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_tenant_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_tenant_subscription` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订阅编号',
  `tenant_id` bigint NOT NULL COMMENT '租户编号',
  `plan_id` bigint NOT NULL COMMENT '当前生效计划编号(计费真相)',
  `plan_snapshot` text COMMENT '下单时计划快照JSON(金额/额度/周期)',
  `quota_used` int NOT NULL DEFAULT '0' COMMENT 'QUOTA 模式已用额度（按订阅累计）',
  `status` varchar(16) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING下单未付/TRIALING试用/ACTIVE生效/PAST_DUE逾期/CANCELLED已取消/EXPIRED过期',
  `billing_cycle` varchar(16) NOT NULL DEFAULT 'MONTHLY' COMMENT 'MONTHLY/ANNUAL',
  `current_start` datetime DEFAULT NULL COMMENT '当前周期开始',
  `current_end` datetime DEFAULT NULL COMMENT '当前周期结束',
  `trial_start` datetime DEFAULT NULL COMMENT '试用开始(默认不启用,DP2)',
  `trial_end` datetime DEFAULT NULL COMMENT '试用结束',
  `cancel_at_period_end` tinyint NOT NULL DEFAULT '0' COMMENT '1=当期末取消续费',
  `cancelled_at` datetime DEFAULT NULL,
  `upgrade_pending_order_id` varchar(64) DEFAULT NULL COMMENT '待付升级订单号(指向sys_payment_recharge_order.order_no,可重开收银台)',
  `upgrade_pending_plan_id` bigint DEFAULT NULL COMMENT '升级目标计划',
  `upgrade_pending_invoice_id` bigint DEFAULT NULL COMMENT '待付升级账单编号',
  `scheduled_billing_cycle` varchar(16) DEFAULT NULL COMMENT '下期切换的周期(仅ANNUAL转MONTHLY免支付)',
  `scheduled_downgrade_plan_id` bigint DEFAULT NULL COMMENT '期末降级目标计划',
  `downgrade_reason` varchar(500) DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  `version` int NOT NULL DEFAULT '0' COMMENT '乐观锁版本',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `renew_fail_count` int DEFAULT '0' COMMENT '续费失败次数',
  `next_retry_time` datetime DEFAULT NULL COMMENT '下次重试时间',
  PRIMARY KEY (`id`),
  KEY `idx_sub_tenant` (`tenant_id`),
  KEY `idx_sub_status_end` (`status`,`current_end`),
  KEY `idx_sub_sched_downgrade` (`scheduled_downgrade_plan_id`),
  KEY `idx_sub_upgrade_pending` (`upgrade_pending_invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户订阅';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_tenant_subscription_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_tenant_subscription_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `price` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT '每周期价格',
  `billing_cycle` varchar(16) NOT NULL DEFAULT 'MONTHLY' COMMENT 'MONTHLY/ANNUAL',
  `quota_model` varchar(16) NOT NULL DEFAULT 'PACKAGE' COMMENT 'PACKAGE套餐/QUOTA额度/METERED用量',
  `daily_limit` int NOT NULL DEFAULT '0' COMMENT '组织共享每日调用上限,0=不限',
  `qps_limit` int NOT NULL DEFAULT '0' COMMENT '组织QPS上限,0=不限',
  `trial_days` int NOT NULL DEFAULT '0' COMMENT '试用天数,0=无试用(DP2)',
  `grace_days` int NOT NULL DEFAULT '7' COMMENT '宽限天数(逾期到过期)',
  `interface_scope` text COMMENT '可调用接口范围JSON:null=全部,[interfaceId..]=白名单(DP7)',
  `status` tinyint NOT NULL DEFAULT '1',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `quota_enforce_mode` varchar(8) DEFAULT 'GRACE' COMMENT '额度拦截模式：GRACE宽限走钱包，STRICT超限拒绝',
  `quota_total` int DEFAULT NULL COMMENT 'QUOTA 模式总额度（null=不限）',
  `quota_used` int DEFAULT '0' COMMENT 'QUOTA 模式已用额度',
  PRIMARY KEY (`id`),
  KEY `idx_sub_plan_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=661 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户订阅计划';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Ticket ID',
  `ticket_no` varchar(32) NOT NULL COMMENT 'Ticket number',
  `user_id` bigint NOT NULL COMMENT 'Creator user ID',
  `type` varchar(20) NOT NULL DEFAULT 'AFTER_SALE' COMMENT 'Type: AFTER_SALE/COMPLAINT/SUGGESTION/BUG',
  `type_id` bigint DEFAULT NULL COMMENT '工单类型编号，关联 sys_ticket_type.id',
  `priority` varchar(10) NOT NULL DEFAULT 'MEDIUM' COMMENT 'Priority: LOW/MEDIUM/HIGH',
  `status` varchar(20) NOT NULL DEFAULT 'draft' COMMENT 'Status: draft/submitted/processing/waiting_feedback/closed',
  `subject` varchar(200) NOT NULL COMMENT 'Subject',
  `content` text NOT NULL COMMENT 'Content',
  `form_data` text COMMENT '自定义表单数据 JSON',
  `interface_id` bigint DEFAULT NULL COMMENT 'Interface ID',
  `provider_id` bigint DEFAULT NULL COMMENT 'Provider ID',
  `assign_type` varchar(10) DEFAULT NULL COMMENT 'Assign type: auto/manual',
  `sla_deadline` datetime DEFAULT NULL COMMENT 'SLA deadline',
  `first_response_at` datetime DEFAULT NULL COMMENT '首次响应时间（受理方首次对用户可见回复）',
  `response_due` datetime DEFAULT NULL COMMENT '首次响应 SLA 截止（按工作时间计算）',
  `resolve_due` datetime DEFAULT NULL COMMENT '解决 SLA 截止（按工作时间计算）',
  `pending_time` datetime DEFAULT NULL COMMENT '进入待反馈时间（Pending 流转基线）',
  `escalated` tinyint NOT NULL DEFAULT '0' COMMENT 'Escalation flag',
  `handler_id` bigint DEFAULT NULL COMMENT 'Handler admin ID',
  `group_id` bigint DEFAULT NULL COMMENT '处理组编号，关联 sys_ticket_group.id',
  `inbox_id` bigint DEFAULT NULL COMMENT '收件箱编号，关联 sys_ticket_inbox.id',
  `channel` varchar(20) NOT NULL DEFAULT 'WEB' COMMENT '来源渠道: WEB/EMAIL/API',
  `close_reason` varchar(500) DEFAULT NULL COMMENT 'Close reason',
  `submit_time` datetime DEFAULT NULL COMMENT 'Submit time',
  `processing_time` datetime DEFAULT NULL COMMENT 'Processing time',
  `closed_time` datetime DEFAULT NULL COMMENT 'Closed time',
  `csat_rating` tinyint DEFAULT NULL COMMENT '满意度评分 1-5',
  `csat_feedback` varchar(500) DEFAULT NULL COMMENT '满意度留言',
  `csat_time` datetime DEFAULT NULL COMMENT '评价时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ticket_no` (`ticket_no`),
  KEY `idx_user_status` (`user_id`,`status`),
  KEY `idx_status_create` (`status`,`create_time`),
  KEY `idx_provider_status` (`provider_id`,`status`),
  KEY `idx_sla` (`escalated`,`sla_deadline`),
  KEY `idx_group` (`group_id`),
  KEY `idx_pending` (`status`,`pending_time`),
  KEY `idx_response_due` (`response_due`),
  KEY `idx_resolve_due` (`resolve_due`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单主表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_agent_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_agent_status` (
  `user_id` bigint NOT NULL COMMENT '座席用户编号',
  `status` varchar(10) NOT NULL DEFAULT 'offline' COMMENT '状态: online/busy/offline',
  `current_load` int NOT NULL DEFAULT '0' COMMENT '当前在手工单数',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单座席状态表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_attachment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '附件编号',
  `ticket_id` bigint NOT NULL COMMENT '工单编号',
  `message_id` bigint NOT NULL COMMENT '所属消息编号',
  `file_name` varchar(255) DEFAULT NULL COMMENT '文件名',
  `file_path` varchar(500) DEFAULT NULL COMMENT '文件路径',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小，字节',
  `file_type` varchar(50) DEFAULT NULL COMMENT '文件类型',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_message_id` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单附件表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_automation_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_automation_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则编号',
  `name` varchar(64) NOT NULL COMMENT '规则名称',
  `event_name` varchar(50) NOT NULL COMMENT '触发事件: ticket.created/submitted/accepted/replied/customer_replied/closed/assigned',
  `conditions` text COMMENT '条件 JSON 数组: [{field,op,value}]，全部满足才执行',
  `actions` text COMMENT '动作 JSON 数组: [{type,value}]',
  `exec_order` int NOT NULL DEFAULT '0' COMMENT '执行顺序（小者优先）',
  `hit_count` bigint NOT NULL DEFAULT '0' COMMENT '命中次数',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态: 0停用 1启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `activator` varchar(16) NOT NULL DEFAULT 'action',
  `delay_hours` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_event_status` (`event_name`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单自动化规则表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '处理组编号',
  `name` varchar(64) NOT NULL COMMENT '处理组名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态: 0停用 1启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单处理组表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_group_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_group_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `group_id` bigint NOT NULL COMMENT '处理组编号',
  `user_id` bigint NOT NULL COMMENT '成员用户编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_user` (`group_id`,`user_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单处理组成员表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_inbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_inbox` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收件箱编号',
  `name` varchar(64) NOT NULL COMMENT '收件箱名称',
  `channel` varchar(20) NOT NULL DEFAULT 'WEB' COMMENT '渠道: WEB/EMAIL/API',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态: 0停用 1启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单收件箱（多渠道）表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_macro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_macro` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '宏编号',
  `name` varchar(64) NOT NULL COMMENT '宏名称',
  `content` text NOT NULL COMMENT '宏内容（回复文本）',
  `scope` varchar(10) NOT NULL DEFAULT 'GLOBAL' COMMENT '作用域: GLOBAL 全局 / PERSONAL 个人',
  `owner_id` bigint DEFAULT NULL COMMENT '个人宏归属用户编号',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态: 0停用 1启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_scope_owner` (`scope`,`owner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单快捷回复宏表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Message ID',
  `ticket_id` bigint NOT NULL COMMENT 'Ticket ID',
  `sender_id` bigint NOT NULL COMMENT 'Sender user ID, 0=system',
  `sender_role` varchar(20) NOT NULL DEFAULT 'USER' COMMENT 'Sender role: USER/PROVIDER/ADMIN/SYSTEM',
  `is_internal` tinyint NOT NULL DEFAULT '0' COMMENT 'Internal note: 0=visible, 1=admin only',
  `content` text NOT NULL COMMENT 'Message content',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ticket_id` (`ticket_id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单消息表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_sla_policy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_sla_policy` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '策略编号',
  `name` varchar(64) NOT NULL COMMENT '策略名称',
  `priority` varchar(10) NOT NULL DEFAULT 'ANY' COMMENT '适用优先级: ANY/LOW/MEDIUM/HIGH/URGENT',
  `type_id` bigint DEFAULT NULL COMMENT '适用工单类型编号，NULL=全部类型',
  `provider_id` bigint DEFAULT NULL,
  `response_hours` int NOT NULL DEFAULT '24' COMMENT '首次响应时效（工作小时）',
  `resolve_hours` int NOT NULL DEFAULT '72' COMMENT '解决时效（工作小时）',
  `work_days` varchar(20) NOT NULL DEFAULT '1,2,3,4,5' COMMENT '工作日（周一=1..周日=7，逗号分隔）',
  `work_start` time NOT NULL DEFAULT '09:00:00' COMMENT '每日工作开始时间',
  `work_end` time NOT NULL DEFAULT '18:00:00' COMMENT '每日工作结束时间',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态: 0停用 1启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单 SLA 策略表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_time_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_time_entry` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint NOT NULL COMMENT '工单编号',
  `user_id` bigint NOT NULL COMMENT '记录人编号',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `duration_sec` int DEFAULT NULL COMMENT '时长（秒），结束时计算',
  `note` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ticket_time_ticket` (`ticket_id`),
  KEY `idx_ticket_time_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单时间跟踪';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '类型编号',
  `code` varchar(64) NOT NULL COMMENT '类型标识（英文，用于程序引用）',
  `name` varchar(64) NOT NULL COMMENT '类型名称（展示给用户）',
  `category` varchar(32) DEFAULT NULL COMMENT '分类：PRODUCT，ACCOUNT，BILLING，SUGGESTION，OTHER',
  `icon` varchar(128) DEFAULT NULL COMMENT '图标',
  `color` varchar(16) DEFAULT '#6b7280' COMMENT '颜色标识',
  `description` varchar(255) DEFAULT NULL COMMENT '类型描述/提示语',
  `form_template` text COMMENT '表单字段模板 JSON（自定义字段配置）',
  `sla_response_hours` int NOT NULL DEFAULT '24' COMMENT 'SLA 响应时效（小时）',
  `sla_resolve_hours` int NOT NULL DEFAULT '72' COMMENT 'SLA 解决时效（小时）',
  `default_assignee_id` bigint DEFAULT NULL COMMENT '默认受理人编号（预留）',
  `is_system` tinyint NOT NULL DEFAULT '0' COMMENT '是否系统内置（不可删除）：1是，0否',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0禁用，1启用',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ticket_type_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单类型表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_ticket_visitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_ticket_visitor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint NOT NULL COMMENT '工单编号',
  `visitor_id` varchar(64) NOT NULL COMMENT '访客标识（前端生成的 UUID）',
  `visitor_name` varchar(100) DEFAULT NULL COMMENT '访客昵称',
  `visitor_email` varchar(128) DEFAULT NULL COMMENT '访客邮箱',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ticket_visitor` (`ticket_id`,`visitor_id`),
  KEY `idx_ticket_visitor_vid` (`visitor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单访客';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_time_trigger_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_time_trigger_lock` (
  `rule_id` bigint NOT NULL,
  `ticket_id` bigint NOT NULL,
  `lock_date` date NOT NULL,
  PRIMARY KEY (`rule_id`,`ticket_id`,`lock_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单时间触发器按日锁表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_track_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_track_link` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `campaign_id` bigint DEFAULT NULL,
  `code` varchar(16) NOT NULL COMMENT '短码',
  `target_url` varchar(500) NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_track_code` (`code`),
  KEY `idx_track_campaign` (`campaign_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='邮件追踪短链';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_upload_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_upload_file` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sha256` char(64) NOT NULL,
  `url` varchar(255) NOT NULL,
  `scene` varchar(32) DEFAULT NULL,
  `size` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sha256_scene` (`sha256`,`scene`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='上传文件表(sha256去重)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户编号',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录账号',
  `password_hash` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '加密密码哈希',
  `real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户姓名',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '头像地址',
  `bio` varchar(255) DEFAULT NULL COMMENT '个人简介',
  `api_count` int NOT NULL DEFAULT '0' COMMENT 'API 数量',
  `verified_status` tinyint NOT NULL DEFAULT '0' COMMENT '认证状态：0 未认证，1 已认证',
  `business_type` varchar(64) DEFAULT NULL COMMENT '主营类型',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '手机号',
  `home_path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '/workspace' COMMENT '登录后首页路径',
  `balance` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '账户余额',
  `points` bigint NOT NULL DEFAULT '0' COMMENT '账户点数',
  `bonus_points` bigint NOT NULL DEFAULT '0' COMMENT '营销积分余额（签到奖励/积分兑换消耗）',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `token_version` int NOT NULL DEFAULT '0' COMMENT 'Token版本号，密码变更后递增',
  `mfa_secret` varchar(64) DEFAULT NULL COMMENT 'TOTP密钥(Base32编码)',
  `mfa_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否启用MFA：0未启用，1已启用',
  `mfa_type` varchar(16) DEFAULT NULL COMMENT 'MFA验证方式：TOTP动态码，EMAIL邮箱验证码',
  `ban_reason` varchar(255) DEFAULT NULL COMMENT '封禁原因',
  `ban_until` datetime DEFAULT NULL COMMENT '临时封禁到期时间，到期自动解封',
  `ban_level` tinyint NOT NULL DEFAULT '0' COMMENT '封禁级别：0正常，1临时封禁，2永久封禁',
  `required_action` varchar(32) DEFAULT NULL COMMENT '登录后强制动作：CHANGE_PASSWORD强制改密，BIND_MFA强制绑定MFA',
  `password_update_time` datetime DEFAULT NULL COMMENT '密码最近修改时间，用于密码过期判断',
  `specified_response_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否指定调用返回信息：1是，0否',
  `specified_response_billable` tinyint NOT NULL DEFAULT '0' COMMENT '指定返回时是否正常计费：1计费，0不计费',
  `specified_response_body` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '指定调用返回内容',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `referral_balance` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT 'Referral commission balance',
  `referral_frozen_balance` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '推介冻结余额',
  `email_deliverable` tinyint NOT NULL DEFAULT '1' COMMENT '邮箱可达(0=退信拉黑)',
  `login_count` int NOT NULL DEFAULT '0' COMMENT '累计登录次数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_sys_user_username` (`username`) USING BTREE,
  UNIQUE KEY `uk_sys_user_email` (`email`) USING BTREE,
  UNIQUE KEY `uk_sys_user_mobile` (`mobile`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=999005160 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统用户表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_api_key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_api_key` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '密钥编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `interface_id` bigint DEFAULT NULL COMMENT '接口编号',
  `key_scope` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'INTERFACE' COMMENT '密钥范围：INTERFACE接口、GLOBAL全站',
  `secret_key` char(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '接口调用密钥',
  `ip_whitelist` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'IP白名单，支持换行或逗号分隔',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `auth_mode` varchar(8) NOT NULL DEFAULT 'PLAIN' COMMENT '认证模式 PLAIN(明文)/HMAC(签名防重放)',
  `expire_time` datetime DEFAULT NULL COMMENT '密钥过期时间',
  `last_used_at` datetime DEFAULT NULL COMMENT '最后使用时间',
  `token_prefix` varchar(8) DEFAULT NULL COMMENT '密钥前缀(掩码展示用)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_api_key_secret_key` (`secret_key`) USING BTREE,
  UNIQUE KEY `uk_user_api_key_user_interface` (`user_id`,`interface_id`) USING BTREE,
  KEY `idx_user_api_key_user` (`user_id`) USING BTREE,
  KEY `idx_user_api_key_interface` (`interface_id`) USING BTREE,
  KEY `idx_user_api_key_scope` (`key_scope`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17329 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户接口密钥表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_attribution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_attribution` (
  `user_id` bigint NOT NULL,
  `first_touch_type` varchar(20) NOT NULL COMMENT 'DIRECT/REFERRAL/UTM_CAMPAIGN/WEBSITE/SEARCH',
  `first_touch_time` datetime NOT NULL,
  `referral_code` varchar(32) DEFAULT NULL,
  `utm_source` varchar(64) DEFAULT NULL,
  `utm_medium` varchar(64) DEFAULT NULL,
  `utm_campaign` varchar(64) DEFAULT NULL,
  `utm_content` varchar(64) DEFAULT NULL,
  `utm_term` varchar(64) DEFAULT NULL,
  `landing_path` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户首触归因(注册时冻结)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_badge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_badge` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `badge_id` bigint NOT NULL,
  `seq` int NOT NULL DEFAULT '0' COMMENT 'multiple_grant 时递增',
  `granted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `granted_by` bigint DEFAULT NULL COMMENT 'NULL/0=系统授予',
  `source_remark` varchar(255) DEFAULT NULL,
  `favorite` tinyint NOT NULL DEFAULT '0' COMMENT '是否精选 0否1是',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_badge_seq` (`badge_id`,`user_id`,`seq`),
  KEY `idx_user_badge_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户徽章';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_bill` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `link_id` varchar(64) DEFAULT NULL COMMENT '关联单号（充值/套餐订单号）',
  `pm` tinyint NOT NULL COMMENT '收支：0支出，1获得',
  `title` varchar(64) NOT NULL COMMENT '流水标题',
  `type` varchar(32) NOT NULL COMMENT '类型：RECHARGE充值/CONSUME消费/REFUND退款/GIFT赠送',
  `number` decimal(12,4) NOT NULL COMMENT '变动金额',
  `balance` decimal(12,4) NOT NULL COMMENT '变动后余额',
  `mark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `group_tag` varchar(8) DEFAULT NULL COMMENT '分组标签',
  `channel_tag` varchar(8) DEFAULT NULL COMMENT '渠道标签',
  PRIMARY KEY (`id`),
  KEY `idx_user_bill_user_time` (`user_id`,`create_time`),
  KEY `idx_user_bill_link` (`link_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户余额流水表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_call_log_cleanup_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_call_log_cleanup_config` (
  `id` tinyint NOT NULL COMMENT '配置编号',
  `enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否启用：1启用，0关闭',
  `cleanup_time` time NOT NULL DEFAULT '01:00:00' COMMENT '每日执行时间',
  `retention_days` int NOT NULL DEFAULT '30' COMMENT '用户侧日志保留天数',
  `last_run_time` datetime DEFAULT NULL COMMENT '最近执行时间',
  `last_hidden_count` bigint NOT NULL DEFAULT '0' COMMENT '最近隐藏日志数量',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `chk_sys_user_call_log_cleanup_config_enabled` CHECK ((`enabled` in (0,1))),
  CONSTRAINT `chk_sys_user_call_log_cleanup_config_retention` CHECK ((`retention_days` between 1 and 3650)),
  CONSTRAINT `chk_sys_user_call_log_cleanup_config_singleton` CHECK ((`id` = 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户调用日志删除配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_exp_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_exp_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户 ID',
  `exp_change` int NOT NULL COMMENT '成长值变化量',
  `exp_after` bigint NOT NULL COMMENT '变化后总成长值',
  `source_type` varchar(32) NOT NULL COMMENT '来源：CONSUMPTION消费/SIGN_IN签到/REALNAME实名/MANUAL手动/OTHER',
  `source_id` varchar(64) DEFAULT NULL COMMENT '关联业务 ID（订单号等）',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_exp_log_user_time` (`user_id`,`create_time`),
  KEY `idx_exp_log_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='成长值明细表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_group` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `qps_limit` int NOT NULL DEFAULT '0',
  `daily_limit` int NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户限流组';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_group_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_group_member` (
  `group_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  UNIQUE KEY `uk_user` (`user_id`),
  KEY `idx_group` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='组成员';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_idp_binding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_idp_binding` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '绑定编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `provider` varchar(16) NOT NULL COMMENT '登录平台: qq/github/gitee/dingtalk/feishu/wechat',
  `open_id` varchar(128) NOT NULL COMMENT '第三方用户唯一标识',
  `union_id` varchar(128) DEFAULT NULL COMMENT '第三方跨应用标识',
  `nickname` varchar(128) DEFAULT NULL COMMENT '第三方昵称',
  `avatar` varchar(500) DEFAULT NULL COMMENT '第三方头像',
  `bind_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '绑定时间',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后第三方登录时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_idp_user` (`user_id`,`provider`),
  UNIQUE KEY `uk_idp_openid` (`provider`,`open_id`),
  KEY `idx_idp_unionid` (`union_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户第三方登录绑定表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_level` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户 ID',
  `level` int NOT NULL DEFAULT '1' COMMENT '当前等级',
  `total_exp` bigint NOT NULL DEFAULT '0' COMMENT '累计成长值（历史总额，只增不减）',
  `current_exp` bigint NOT NULL DEFAULT '0' COMMENT '当前等级内的成长值（用于进度条）',
  `upgrade_time` datetime DEFAULT NULL COMMENT '最近一次升级时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_level_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户等级表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_level_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_level_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户 ID',
  `old_level` int NOT NULL COMMENT '变动前等级',
  `new_level` int NOT NULL COMMENT '变动后等级',
  `old_total_exp` bigint NOT NULL COMMENT '变动前累计成长值',
  `new_total_exp` bigint NOT NULL COMMENT '变动后累计成长值',
  `change_type` varchar(16) NOT NULL COMMENT '变动类型：UPGRADE 升级，DOWNGRADE 降级',
  `source_type` varchar(32) NOT NULL COMMENT '来源：CONSUMPTION/SIGN_IN/REALNAME/MANUAL/OTHER',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_level_record_user` (`user_id`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员等级变动记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户 ID',
  `type` varchar(32) NOT NULL DEFAULT 'LEVEL_UP' COMMENT '消息类型：LEVEL_UP等级升级/SYSTEM系统',
  `title` varchar(128) NOT NULL COMMENT '标题',
  `content` varchar(500) NOT NULL COMMENT '内容',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已读',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_message_user` (`user_id`,`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户站内消息表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_mfa_recovery_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_mfa_recovery_code` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `code_hash` varchar(100) NOT NULL,
  `used` tinyint NOT NULL DEFAULT '0',
  `used_time` datetime DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_status` (`user_id`,`used`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户MFA恢复码表(哈希存储)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_notify_pref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_notify_pref` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `notify_code` varchar(32) NOT NULL,
  `enabled` tinyint NOT NULL DEFAULT '1',
  `channel` varchar(16) NOT NULL DEFAULT 'SITE' COMMENT '通知渠道 SITE/EMAIL',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_notify_pref_channel` (`user_id`,`notify_code`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户通知偏好（按类型开关）';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_operation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `user_id` bigint NOT NULL COMMENT '操作用户编号',
  `username` varchar(64) NOT NULL COMMENT '用户名（冗余）',
  `operation_type` varchar(32) NOT NULL COMMENT '操作类型：LOGIN，LOGOUT，PROFILE，PASSWORD，API_KEY，WITHDRAW，PACKAGE，REDEEM，OTHER',
  `operation_name` varchar(128) NOT NULL COMMENT '操作名称',
  `event_type` varchar(64) DEFAULT '' COMMENT '细分事件类型，如 LOGIN_SUCCESS / LOGIN_FAILED，为空沿用 operation_type',
  `target` varchar(255) DEFAULT '' COMMENT '操作对象标识（注解 SpEL 求值）',
  `struct_params` text COMMENT '结构化参数 JSON（注解 SpEL 求值，脱敏后）',
  `method` varchar(16) DEFAULT NULL COMMENT '请求方法',
  `request_uri` varchar(255) DEFAULT NULL COMMENT '请求 URI',
  `request_params` text COMMENT '请求参数 JSON（脱敏后）',
  `response_result` text COMMENT '响应结果摘要',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '操作状态：0失败，1成功',
  `ip_address` varchar(64) DEFAULT NULL COMMENT '操作 IP',
  `ip_location` varchar(128) DEFAULT NULL COMMENT 'IP 归属地',
  `user_agent` varchar(512) DEFAULT NULL COMMENT '浏览器 UA',
  `cost_time` int DEFAULT NULL COMMENT '耗时（毫秒）',
  `error_msg` varchar(512) DEFAULT NULL COMMENT '错误信息',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_time` (`user_id`,`create_time`),
  KEY `idx_type_time` (`operation_type`,`create_time`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户操作日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_package_global`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_package_global` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户全站套餐编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `package_id` bigint NOT NULL COMMENT '全站套餐编号',
  `package_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '购买时套餐名称快照',
  `daily_limit` int NOT NULL DEFAULT '0' COMMENT '购买时每日调用上限快照，0表示无限调用',
  `qps_limit` int NOT NULL DEFAULT '0' COMMENT '购买时每秒调用QPS上限快照，0表示不限制',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `start_time` datetime DEFAULT NULL COMMENT '生效时间',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_package_global_user` (`user_id`) USING BTREE,
  KEY `idx_user_package_global_package` (`package_id`) USING BTREE,
  KEY `idx_user_package_global_time` (`start_time`,`expire_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户全站套餐开通表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_package_interface`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_package_interface` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户接口套餐编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `interface_id` bigint NOT NULL COMMENT '接口编号',
  `package_id` bigint NOT NULL COMMENT '接口套餐编号',
  `spec_id` bigint NOT NULL COMMENT '套餐规格编号',
  `package_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '购买时套餐名称快照',
  `spec_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '购买时规格名称快照',
  `daily_limit` int NOT NULL DEFAULT '0' COMMENT '购买时每日调用上限快照，0表示无限调用',
  `qps_limit` int NOT NULL DEFAULT '0' COMMENT '购买时每秒调用QPS上限快照，0表示不限制',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `start_time` datetime DEFAULT NULL COMMENT '生效时间',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_package_interface_user` (`user_id`) USING BTREE,
  KEY `idx_user_package_interface_api` (`interface_id`) USING BTREE,
  KEY `idx_user_package_interface_spec` (`spec_id`) USING BTREE,
  KEY `idx_user_package_interface_time` (`start_time`,`expire_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户接口套餐开通表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_registration_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_registration_source` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `referrer_type` varchar(20) NOT NULL COMMENT 'DIRECT/REFERRAL/UTM_CAMPAIGN/WEBSITE/SEARCH',
  `referral_code` varchar(32) DEFAULT NULL,
  `utm_source` varchar(64) DEFAULT NULL,
  `utm_medium` varchar(64) DEFAULT NULL,
  `utm_campaign` varchar(64) DEFAULT NULL,
  `page_path` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_reg_source_user` (`user_id`),
  KEY `idx_reg_source_type` (`referrer_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='注册来源归因快照';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `role_id` bigint NOT NULL COMMENT '角色编号',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE,
  KEY `idx_sys_user_role_role` (`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_segment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_segment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `filter_json` json NOT NULL COMMENT '条件树 {op:AND/OR, rules:[{field,operand,value}]}',
  `member_count` int NOT NULL DEFAULT '0',
  `last_rebuild_time` datetime DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_segment_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户分群';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_segment_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_segment_member` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `segment_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `source` varchar(16) NOT NULL DEFAULT 'RULE' COMMENT 'RULE/MANUAL/SNAPSHOT',
  `override_type` varchar(8) DEFAULT NULL COMMENT 'INCLUDE/EXCLUDE 手工覆盖',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_segment_user` (`segment_id`,`user_id`),
  KEY `idx_seg_member_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分群成员(手工覆盖位)';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_session` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '会话编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `username` varchar(64) NOT NULL COMMENT '用户名',
  `jti` varchar(64) NOT NULL COMMENT 'Refresh Token唯一标识',
  `device_fingerprint` varchar(32) DEFAULT NULL COMMENT '设备指纹',
  `device_type` varchar(16) NOT NULL DEFAULT 'UNKNOWN' COMMENT '设备类型：PC电脑端，MOBILE手机端，TABLET平板端，UNKNOWN未知',
  `user_agent` varchar(255) DEFAULT NULL COMMENT '浏览器标识',
  `user_ip` varchar(64) DEFAULT NULL COMMENT '登录IP',
  `login_time` datetime NOT NULL COMMENT '登录时间',
  `expire_time` datetime NOT NULL COMMENT '会话过期时间',
  `status` varchar(16) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE在线，REVOKED已下线',
  `revoke_time` datetime DEFAULT NULL COMMENT '下线时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_session_jti` (`jti`),
  KEY `idx_user_session_user` (`user_id`,`status`),
  KEY `idx_user_session_expire` (`expire_time`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户登录会话表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_sign_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_sign_in` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户 ID',
  `sign_date` date NOT NULL COMMENT '签到日期（yyyy-MM-dd）',
  `is_makeup` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否补签',
  `sign_type` tinyint NOT NULL DEFAULT '1' COMMENT '1正常/2补签/3freeze',
  `points_reward` int NOT NULL DEFAULT '0' COMMENT '获得积分',
  `exp_reward` int NOT NULL DEFAULT '0' COMMENT '获得成长值',
  `balance_reward` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '获得余额（元）',
  `continuous_days` int NOT NULL DEFAULT '0' COMMENT '本次签到时的连续天数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '签到时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_sign_date` (`user_id`,`sign_date`),
  KEY `idx_sign_date` (`sign_date`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='签到记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_sign_in_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_sign_in_stats` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户 ID',
  `total_days` int NOT NULL DEFAULT '0' COMMENT '累计签到天数',
  `continuous_days` int NOT NULL DEFAULT '0' COMMENT '当前连续签到天数',
  `max_continuous_days` int NOT NULL DEFAULT '0' COMMENT '历史最长连续天数',
  `last_sign_date` date DEFAULT NULL COMMENT '最近（非补签）签到日期',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `freeze_cards` int NOT NULL DEFAULT '0',
  `weekly_streak` int NOT NULL DEFAULT '0',
  `last_week_achieved` tinyint NOT NULL DEFAULT '0',
  `last_computed_week` date DEFAULT NULL COMMENT '周口径幂等游标：最后计算的自然周周一',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sign_stats_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户签到统计表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_subscription` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订阅编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `plan_id` bigint NOT NULL COMMENT '套餐计划编号',
  `frequency` varchar(16) NOT NULL DEFAULT 'MONTHLY' COMMENT '计费周期：MONTHLY月付，ANNUAL年付',
  `next_renew_date` datetime DEFAULT NULL COMMENT '下次续费日期',
  `remaining_cycles` int DEFAULT NULL COMMENT '剩余周期数（null=无限续费）',
  `status` varchar(16) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：TRIAL试用，ACTIVE有效，EXPIRED过期，CANCELLED已取消',
  `auto_renew` tinyint NOT NULL DEFAULT '1' COMMENT '是否自动续费：1是，0否',
  `trial_end_time` datetime DEFAULT NULL COMMENT '试用结束时间（null=非试用）',
  `entitlement_snapshot` text COMMENT '权益快照',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_plan` (`user_id`,`plan_id`),
  KEY `idx_user_sub_renew` (`status`,`next_renew_date`),
  KEY `idx_user_sub_trial` (`status`,`trial_end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户级订阅表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_table_pref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_table_pref` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `table_key` varchar(64) NOT NULL,
  `pref_json` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_table` (`user_id`,`table_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表格列偏好';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `tag` varchar(64) NOT NULL,
  `source` varchar(16) NOT NULL DEFAULT 'MANUAL' COMMENT 'MANUAL/SEGMENT',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_tag` (`user_id`,`tag`),
  KEY `idx_tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户标签';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_user_timeline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_timeline` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `event_type` varchar(32) NOT NULL COMMENT 'LEVEL_UP/BADGE/STREAK_MILESTONE/EXCHANGE/FREEZE',
  `title` varchar(128) NOT NULL,
  `detail` varchar(500) DEFAULT NULL,
  `ref_type` varchar(32) DEFAULT NULL,
  `ref_id` bigint DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_timeline_user` (`user_id`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户成长时间线';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_vip_faq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_vip_faq` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `question` varchar(255) NOT NULL COMMENT '问题',
  `answer` varchar(1000) NOT NULL COMMENT '回答',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1启用 0禁用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员价格页常见问题';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_wallet_credit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_wallet_credit_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水编号',
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `amount` decimal(12,4) NOT NULL COMMENT '变动金额（正=充入，负=扣减）',
  `balance_after` decimal(12,4) NOT NULL COMMENT '变动后信用余额',
  `type` varchar(32) NOT NULL COMMENT '类型：RECHARGE充值，CONSUME消费，EXPIRE过期，ADJUST调整',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间（FIFO 扣减依据）',
  `status` varchar(16) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE有效，EXPIRED已过期，USED已用尽',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_wallet_credit_user` (`user_id`,`status`,`expire_time`),
  KEY `idx_wallet_credit_expire` (`expire_time`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='预付信用余额流水表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_webhook_callback_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_webhook_callback_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `order_no` varchar(64) DEFAULT NULL COMMENT '关联订单号',
  `event_type` varchar(64) DEFAULT NULL COMMENT '事件类型',
  `payload` mediumtext COMMENT '回调原始报文',
  `status` varchar(16) NOT NULL DEFAULT 'RECEIVED' COMMENT '处理状态：RECEIVED已接收，PROCESSED已处理，FAILED失败',
  `error_msg` varchar(512) DEFAULT NULL COMMENT '错误信息',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_webhook_callback_order` (`order_no`),
  KEY `idx_webhook_callback_status` (`status`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='发货回调日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_webhook_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_webhook_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `subscription_id` bigint NOT NULL,
  `event_type` varchar(64) NOT NULL,
  `payload` text COMMENT '请求体JSON',
  `response_code` int DEFAULT NULL COMMENT '响应状态码',
  `response_body` text COMMENT '响应体(截断)',
  `error_message` varchar(500) DEFAULT NULL,
  `attempt` int NOT NULL DEFAULT '1' COMMENT '第几次重试',
  `status` varchar(16) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/SUCCESS/FAILED',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_webhook_log_sub` (`subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Webhook 推送日志';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sys_webhook_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_webhook_subscription` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '订阅用户',
  `event_type` varchar(64) NOT NULL COMMENT '事件类型如 CALL_SUCCESS/KEY_EXPIRE',
  `url` varchar(512) NOT NULL COMMENT '回调地址',
  `secret` varchar(128) DEFAULT NULL COMMENT 'HMAC 签名密钥',
  `headers_json` text COMMENT '自定义请求头JSON',
  `retries` int NOT NULL DEFAULT '3' COMMENT '重试次数',
  `retry_interval_ms` int NOT NULL DEFAULT '60000' COMMENT '重试间隔(ms)',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1启用/0停用',
  `fail_count` int NOT NULL DEFAULT '0' COMMENT '累计失败次数',
  `last_push_time` datetime DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_webhook_user` (`user_id`),
  KEY `idx_webhook_event` (`event_type`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='事件 Webhook 订阅';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;



/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

LOCK TABLES `sys_site_config` WRITE;
/*!40000 ALTER TABLE `sys_site_config` DISABLE KEYS */;
INSERT INTO `sys_site_config` VALUES (1,'正贤Api管理平台','','/api/upload/site-logo/039f29a1733a46c78207680ba349d417.png','一个平台，掌控所有 API','聚合接口、智能计费、实时监控，构建你的 API 服务生态。','','','','',NULL,'','',NULL,NULL,'© 2026 正贤Api. All rights reserved.','[{\"label\":\"首页\",\"path\":\"/\"},{\"label\":\"API市场\",\"path\":\"/apilist\"},{\"label\":\"会员价格\",\"path\":\"/vip\"},{\"label\":\"服务商\",\"path\":\"/provider-plaza\"},{\"label\":\"帮助文档\",\"path\":\"/doc\"},{\"label\":\"友链\",\"path\":\"/links\"}]','2026-07-26 20:15:11','2026-10-15 22:43:27');
/*!40000 ALTER TABLE `sys_site_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'admin','系统管理员',1,1,'2026-07-26 20:15:11','2026-10-27 04:37:49','系统内置角色'),(2,'user','普通用户',1,1,'2026-07-26 20:15:11','2026-10-27 04:37:49','系统内置角色'),(3,'provider','服务商',1,1,'2026-08-15 00:21:35','2026-10-27 04:37:49','系统内置角色');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (100,0,'Dashboard','/dashboard',NULL,NULL,'/analytics','page.dashboard.title','mingcute:dashboard-line','catalog',NULL,0,NULL,NULL,0,1,'2026-07-26 20:15:11','2026-09-05 20:02:43'),(101,100,'Analytics','/analytics','/dashboard/analytics/index',NULL,NULL,'menu.dashboard.bigScreen','mingcute:chart-bar-2-line','menu',NULL,10,1,1,NULL,1,'2026-07-26 20:15:11','2026-09-05 19:57:28'),(102,0,'Workspace','/workspace','/dashboard/workspace/index',NULL,NULL,'page.dashboard.workspace','mdi:view-dashboard-outline','menu',NULL,10,1,1,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:46:40'),(200,0,'System','/system',NULL,NULL,NULL,'system.title','mdi:cog-outline','catalog',NULL,90,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:46:40'),(201,400,'SystemRole','/user/role','/system/role/list',NULL,NULL,'system.role.title','mdi:account-group','menu','System:Role:List',20,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(202,200,'SystemMenu','/system/menu','/system/menu/list',NULL,NULL,'system.menu.title','mdi:menu','menu','System:Menu:List',10,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(204,201,'SystemRoleCreate','/user/role/create',NULL,NULL,NULL,'common.create',NULL,'button','System:Role:Create',21,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(205,201,'SystemRoleEdit','/user/role/edit',NULL,NULL,NULL,'common.edit',NULL,'button','System:Role:Edit',22,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(206,201,'SystemRoleDelete','/user/role/delete',NULL,NULL,NULL,'common.delete',NULL,'button','System:Role:Delete',23,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(207,202,'SystemMenuCreate','/system/menu/create',NULL,NULL,NULL,'common.create',NULL,'button','System:Menu:Create',11,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(208,202,'SystemMenuEdit','/system/menu/edit',NULL,NULL,NULL,'common.edit',NULL,'button','System:Menu:Edit',12,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(209,202,'SystemMenuDelete','/system/menu/delete',NULL,NULL,NULL,'common.delete',NULL,'button','System:Menu:Delete',13,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(211,200,'SystemSiteConfig','/system/site','/system/site/index',NULL,NULL,'menu.system.siteConfig','mdi:web-sync','menu','System:Site:Config',30,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(212,200,'SystemLogDelete','/system/log-delete','/system/log-delete/index',NULL,NULL,'menu.log.clean','mdi:delete-clock-outline','menu','System:LogDelete:Config',40,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(250,0,'RegisterManage','/register',NULL,NULL,NULL,'注册管理','mdi:account-cog-outline','catalog',NULL,70,NULL,NULL,NULL,1,'2026-09-28 23:53:54','2026-09-28 23:54:04'),(251,250,'RegisterBasicConfig','/register/basic','/system/register/index',NULL,NULL,'注册配置','mdi:cog-outline','menu','System:Register:Config',10,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-19 02:03:49'),(254,0,'LoginManage','/login-manage',NULL,NULL,'/login-manage/third-party','menu.login.title','mdi:login-variant','catalog',NULL,75,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-29 23:29:54'),(255,254,'ThirdPartyLogin','/login-manage/third-party','/system/login/third-party-login',NULL,NULL,'第三方登录','mdi:qqchat','menu','System:Login:Quick',10,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-09 14:12:01'),(256,254,'OnlineUsers','/login-manage/online-users','/system/online-user/list',NULL,NULL,'menu.login.onlineUsers','mdi:account-multiple-check-outline','menu','System:OnlineUser:List',20,NULL,NULL,NULL,1,'2026-09-05 23:20:14','2026-09-05 23:20:14'),(257,254,'CaptchaConfig','/login-manage/captcha','/system/captcha-config/index',NULL,NULL,'menu.login.captcha','mdi:shield-check-outline','menu','System:Captcha:Config',30,NULL,NULL,NULL,1,'2026-09-05 23:20:14','2026-09-05 23:20:14'),(301,0,'Profile','/profile','/_core/profile/index',NULL,NULL,'page.auth.profile','mingcute:user-4-line','menu',NULL,9998,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-08-13 15:55:43'),(400,0,'UserManagement','/user',NULL,NULL,'/user/list','system.user.title','mdi:account-cog','catalog',NULL,20,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(401,400,'SystemUser','/user/list','/system/user/list',NULL,NULL,'system.user.listTitle','mdi:account','menu','System:User:List',10,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(402,401,'SystemUserCreate','/user/list/create',NULL,NULL,NULL,'common.create',NULL,'button','System:User:Create',11,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(403,401,'SystemUserEdit','/user/list/edit',NULL,NULL,NULL,'common.edit',NULL,'button','System:User:Edit',12,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(404,401,'SystemUserDelete','/user/list/delete',NULL,NULL,NULL,'common.delete',NULL,'button','System:User:Delete',13,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(500,0,'InterfaceManagement','/interface',NULL,NULL,'/interface/list','system.interface.title','mdi:api','catalog',NULL,30,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(501,500,'InterfaceList','/interface/list','/interface/list',NULL,NULL,'system.interface.listTitle','mdi:api','menu','Interface:Api:List',10,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(502,501,'InterfaceCreate','/interface/list/create',NULL,NULL,NULL,'common.create',NULL,'button','Interface:Api:Create',11,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(503,501,'InterfaceEdit','/interface/list/edit',NULL,NULL,NULL,'common.edit',NULL,'button','Interface:Api:Edit',12,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(504,501,'InterfaceDelete','/interface/list/delete',NULL,NULL,NULL,'common.delete',NULL,'button','Interface:Api:Delete',13,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(505,501,'InterfaceInvoke','/interface/list/invoke',NULL,NULL,NULL,'system.interface.invoke',NULL,'button','Interface:Api:Invoke',14,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(507,501,'InterfaceBillingRule','/interface/list/billing-rule',NULL,NULL,NULL,'system.interface.billingRule',NULL,'button','Interface:Api:BillingRule',15,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(508,500,'InterfaceCallLog','/interface/log','/interface/log',NULL,NULL,'system.interface.callLogTitle','mdi:clipboard-text-clock','menu','Interface:CallLog:List',20,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(600,0,'KeyManagement','/key','/key/list',NULL,NULL,'system.key.title','mdi:key-chain','menu','Key:Api:List',30,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(601,600,'KeyCreate','/key/create',NULL,NULL,NULL,'common.create',NULL,'button','Key:Api:Create',1,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(602,600,'KeyDelete','/key/delete',NULL,NULL,NULL,'common.delete',NULL,'button','Key:Api:Delete',2,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(603,600,'KeyRegenerate','/key/regenerate',NULL,NULL,NULL,'system.key.regenerate',NULL,'button','Key:Api:Regenerate',3,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(604,600,'KeyStatus','/key/status',NULL,NULL,NULL,'system.key.status',NULL,'button','Key:Api:Status',4,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(605,600,'KeyIpWhitelist','/key/ip-whitelist',NULL,NULL,NULL,'system.key.ipWhitelistManage',NULL,'button','Key:Api:IpWhitelist',5,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(700,0,'PackageManagement','/package',NULL,NULL,'/package/global','system.package.title','mdi:package-variant-closed','catalog',NULL,40,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(701,700,'GlobalPackage','/package/global','/package/config/index',NULL,NULL,'套餐配置','mdi:web','menu','Package:Global:List',10,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-19 02:19:33'),(703,701,'GlobalPackageCreate','/package/global/create',NULL,NULL,NULL,'common.create',NULL,'button','Package:Global:Create',11,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(704,701,'GlobalPackageEdit','/package/global/edit',NULL,NULL,NULL,'common.edit',NULL,'button','Package:Global:Edit',12,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(705,701,'GlobalPackageDelete','/package/global/delete',NULL,NULL,NULL,'common.delete',NULL,'button','Package:Global:Delete',13,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(709,701,'GlobalPackageOpen','/package/global/open',NULL,NULL,NULL,'system.package.openPackage',NULL,'button','Package:Global:Open',14,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(800,0,'PackagePurchase','/purchase',NULL,NULL,'/purchase/global','system.package.purchaseTitle','mdi:cart-outline','catalog',NULL,20,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(801,800,'UserGlobalPackage','/purchase/global','/purchase/global/list',NULL,NULL,'system.package.buyGlobalTitle','mdi:shopping-outline','menu','Package:Mall:Global',10,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(802,800,'UserInterfacePackage','/purchase/interface','/purchase/interface/list',NULL,NULL,'system.package.buyInterfaceTitle','mdi:shopping-outline','menu','Package:Mall:Interface',20,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(803,800,'UserInterfacePackageDetail','/purchase/interface/detail','/purchase/interface/detail',NULL,NULL,'system.package.interfacePackageBuy','mdi:receipt-text-outline','menu','Package:Mall:InterfaceDetail',40,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-10-01 02:10:11'),(804,800,'UserPointPackage','/purchase/point','/purchase/point/list',NULL,NULL,'system.package.buyPointTitle','mdi:database-plus','menu','Package:Mall:Point',30,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(805,0,'UserPaymentOrder','/purchase/orders','/payment/order/user',NULL,NULL,'menu.finance.transactions','mdi:receipt-clock-outline','menu','Payment:Order:User',60,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(900,0,'PaymentManagement','/payment',NULL,NULL,'/payment/config','system.payment.title','mdi:credit-card-settings-outline','catalog',NULL,50,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(901,900,'PaymentConfig','/payment/config','/payment/config/index',NULL,NULL,'system.payment.configTitle','mdi:credit-card-settings-outline','menu','Payment:Config:Alipay',10,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(902,901,'PaymentConfigSave','/payment/config/save',NULL,NULL,NULL,'common.save',NULL,'button','Payment:Config:Save',11,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(903,901,'PaymentConfigValidate','/payment/config/validate',NULL,NULL,NULL,'system.payment.validate',NULL,'button','Payment:Config:Validate',12,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(904,900,'PaymentOrder','/payment/orders','/payment/order/index',NULL,NULL,'menu.payment.orders','mdi:receipt-text-clock-outline','menu','Payment:Order:List',30,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(905,900,'PaymentAmountConfig','/payment/amounts','/payment/amount/index',NULL,NULL,'system.payment.amountTitle','mdi:cash-plus','menu','Payment:Amount:List',20,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(906,905,'PaymentAmountCreate','/payment/amounts/create',NULL,NULL,NULL,'common.create',NULL,'button','Payment:Amount:Create',21,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(907,905,'PaymentAmountEdit','/payment/amounts/edit',NULL,NULL,NULL,'common.edit',NULL,'button','Payment:Amount:Edit',22,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(908,905,'PaymentAmountDelete','/payment/amounts/delete',NULL,NULL,NULL,'common.delete',NULL,'button','Payment:Amount:Delete',23,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(909,905,'PaymentAmountStatus','/payment/amounts/status',NULL,NULL,NULL,'状态',NULL,'button','Payment:Amount:Status',24,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(910,900,'PaymentNotifyLog','/payment/notify-logs','/payment/notify-log/index',NULL,NULL,'menu.payment.notifyLog','mdi:message-badge-outline','menu','Payment:NotifyLog:List',40,NULL,NULL,NULL,1,'2026-09-05 23:20:15','2026-09-05 23:20:15'),(911,900,'PaymentRefund','/payment/refunds','/payment/refund/index',NULL,NULL,'menu.payment.refund','mdi:cash-refund','menu','Payment:Refund:List',50,NULL,NULL,NULL,1,'2026-09-05 23:20:15','2026-09-05 23:20:15'),(1000,0,'NoticeManagement','/notice-admin',NULL,NULL,'/notice-admin/list','menu.notice.title','mdi:bullhorn-outline','catalog',NULL,60,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(1001,1000,'NoticeAdminList','/notice-admin/list','/notice/admin/list',NULL,NULL,'menu.notice.list','mdi:clipboard-text-outline','menu','Notice:Admin:List',10,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(1002,1001,'NoticeCreate','/notice-admin/list/create',NULL,NULL,NULL,'common.create',NULL,'button','Notice:Admin:Create',11,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1003,1001,'NoticeEdit','/notice-admin/list/edit',NULL,NULL,NULL,'common.edit',NULL,'button','Notice:Admin:Edit',12,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1004,1001,'NoticeDelete','/notice-admin/list/delete',NULL,NULL,NULL,'common.delete',NULL,'button','Notice:Admin:Delete',13,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1005,1001,'NoticeStatus','/notice-admin/list/status',NULL,NULL,NULL,'状态',NULL,'button','Notice:Admin:Status',14,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1006,1001,'NoticeTop','/notice-admin/list/top',NULL,NULL,NULL,'置顶',NULL,'button','Notice:Admin:Top',15,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1007,0,'UserNoticeCenter','/notice','/notice/user/list',NULL,NULL,'menu.notice.list','mdi:bullhorn-outline','menu','Notice:User:List',70,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(1008,1001,'NoticePopup','/notice-admin/list/popup',NULL,NULL,NULL,'每日弹窗',NULL,'button','Notice:Admin:Popup',16,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1009,1000,'NoticeHomeNotice','/notice-admin/home-notice','/notice/admin/home-notice/index',NULL,NULL,'menu.notice.homeConfig','mdi:bullhorn-variant-outline','menu','Notice:Admin:HomeConfig',20,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(1100,0,'FriendLinkManagement','/friend-link',NULL,NULL,'/friend-link/list','menu.friendLink.title','mdi:link-variant','catalog',NULL,80,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(1101,1100,'FriendLinkList','/friend-link/list','/friend-link/list',NULL,NULL,'menu.friendLink.list','mdi:link-box-variant-outline','menu','FriendLink:List',10,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(1102,1101,'FriendLinkCreate','/friend-link/list/create',NULL,NULL,NULL,'common.create',NULL,'button','FriendLink:Create',11,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1103,1101,'FriendLinkEdit','/friend-link/list/edit',NULL,NULL,NULL,'common.edit',NULL,'button','FriendLink:Edit',12,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1104,1101,'FriendLinkDelete','/friend-link/list/delete',NULL,NULL,NULL,'common.delete',NULL,'button','FriendLink:Delete',13,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1105,1101,'FriendLinkStatus','/friend-link/list/status',NULL,NULL,NULL,'状态',NULL,'button','FriendLink:Status',14,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1110,1100,'FriendLinkApplication','/friend-link/applications','/friend-link/applications',NULL,NULL,'menu.friendLink.applications','mdi:link-plus','menu','FriendLink:Application:List',20,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(1111,1110,'FriendLinkApplicationApprove','/friend-link/applications/approve',NULL,NULL,NULL,'通过',NULL,'button','FriendLink:Application:Approve',21,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1112,1110,'FriendLinkApplicationReject','/friend-link/applications/reject',NULL,NULL,NULL,'驳回',NULL,'button','FriendLink:Application:Reject',22,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1113,1110,'FriendLinkApplicationConfig','/friend-link/applications/config',NULL,NULL,NULL,'申请开关',NULL,'button','FriendLink:Application:Config',23,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1200,0,'RedeemCardManagement','/redeem-card',NULL,NULL,'/redeem-card/generate','menu.cardKey.title','mdi:ticket-confirmation-outline','catalog',NULL,65,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(1201,1200,'RedeemCardGenerate','/redeem-card/generate','/redeem-card/generate/index',NULL,NULL,'menu.cardKey.generate','mdi:ticket-percent-outline','menu','RedeemCard:Generate',10,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(1202,1200,'RedeemCardLog','/redeem-card/log','/redeem-card/log/index',NULL,NULL,'menu.cardKey.logs','mdi:clipboard-text-clock-outline','menu','RedeemCard:Log:List',20,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(1203,1201,'RedeemCardCreate','/redeem-card/generate/create',NULL,NULL,NULL,'common.create',NULL,'button','RedeemCard:Create',11,NULL,NULL,1,1,'2026-07-26 20:15:11','2026-07-26 20:15:11'),(1204,1200,'RedeemCardOpen','/redeem-card/open','/redeem-card/open/index',NULL,NULL,'menu.cardKey.publicInterface','mdi:api','menu','RedeemCard:Open:List',30,NULL,NULL,NULL,1,'2026-07-26 20:15:11','2026-09-05 18:09:37'),(1300,0,'GlossaryList','/glossary/list','/glossary/list',NULL,NULL,'menu.term.title','mdi:book-alphabet','menu','Glossary:List',64,NULL,NULL,NULL,1,'2026-07-27 00:24:11','2026-09-05 20:18:03'),(1301,700,'VipFaqList','/vip-faq/list','/vip-faq/list',NULL,NULL,'menu.vip.faq','mingcute:question-line','menu','Package:Member:List',0,NULL,NULL,NULL,1,'2026-09-05 15:42:02','2026-09-05 18:09:37'),(1400,500,'InterfaceCategory','/interface/category','/interface/category/index',NULL,NULL,'menu.interface.category','mdi:shape-outline','menu','Interface:Category:List',5,NULL,NULL,NULL,1,'2026-08-15 02:36:55','2026-09-05 18:09:37'),(1401,1400,'InterfaceCategoryCreate','/interface/category/create',NULL,NULL,NULL,'common.create',NULL,'button','Interface:Category:Create',1,NULL,NULL,1,1,'2026-08-15 02:36:55','2026-08-15 02:36:55'),(1402,1400,'InterfaceCategoryEdit','/interface/category/edit',NULL,NULL,NULL,'common.edit',NULL,'button','Interface:Category:Edit',2,NULL,NULL,1,1,'2026-08-15 02:36:55','2026-08-15 02:36:55'),(1403,1400,'InterfaceCategoryDelete','/interface/category/delete',NULL,NULL,NULL,'common.delete',NULL,'button','Interface:Category:Delete',3,NULL,NULL,1,1,'2026-08-15 02:36:55','2026-08-15 02:36:55'),(1500,0,'ProviderCenter','/provider',NULL,NULL,NULL,'menu.provider.home','mdi:storefront','catalog',NULL,0,NULL,NULL,NULL,1,'2026-08-15 02:37:09','2026-09-05 18:09:37'),(1501,1500,'ProviderApply','/provider/apply','/provider/apply',NULL,NULL,'menu.provider.apply','mdi:file-document-edit-outline','menu','Provider:Apply',0,NULL,NULL,1,1,'2026-08-15 02:37:09','2026-09-05 18:09:37'),(1502,1500,'ProviderInterfaceList','/provider/interfaces','/provider/interface-list',NULL,NULL,'menu.provider.myInterfaces','mdi:api','menu','Provider:Interface:List',0,NULL,NULL,NULL,1,'2026-08-15 02:37:09','2026-09-05 18:09:37'),(1503,1502,'ProviderInterfaceCreate','/provider/interfaces/create',NULL,NULL,NULL,'发布',NULL,'button','Provider:Interface:Create',21,NULL,NULL,1,1,'2026-08-15 02:37:09','2026-08-15 02:37:09'),(1504,1502,'ProviderInterfaceEdit','/provider/interfaces/edit',NULL,NULL,NULL,'编辑',NULL,'button','Provider:Interface:Edit',22,NULL,NULL,1,1,'2026-08-15 02:37:09','2026-08-15 02:37:09'),(1505,1502,'ProviderInterfaceStatus','/provider/interfaces/status',NULL,NULL,NULL,'上下架',NULL,'button','Provider:Interface:Status',23,NULL,NULL,1,1,'2026-08-15 02:37:09','2026-08-15 02:37:09'),(1506,1502,'ProviderInterfaceDelete','/provider/interfaces/delete',NULL,NULL,NULL,'common.delete',NULL,'button','Provider:Interface:Delete',24,NULL,NULL,1,1,'2026-08-15 02:37:09','2026-08-15 02:37:09'),(1507,1500,'ProviderEarnings','/provider/earnings','/provider/earnings',NULL,NULL,'menu.provider.income','mdi:chart-line','menu','Provider:Earning:List',30,NULL,NULL,NULL,1,'2026-08-15 02:37:09','2026-09-05 18:09:37'),(1508,1500,'ProviderWithdraw','/provider/withdraw','/provider/withdraw',NULL,NULL,'menu.provider.withdraw','mdi:cash-multiple','menu','Provider:Withdraw:List',40,NULL,NULL,NULL,1,'2026-08-15 02:37:09','2026-09-05 18:09:37'),(1509,1500,'ProviderCallLog','/provider/call-log','/provider/call-log',NULL,NULL,'menu.provider.callLog','mdi:clipboard-text-clock','menu','Provider:CallLog:List',50,NULL,NULL,NULL,1,'2026-08-15 02:37:09','2026-09-05 18:09:37'),(1520,0,'ProviderManagement','/provider-admin',NULL,NULL,'/provider-admin/applications','menu.providerAdmin.title','mdi:account-supervisor','catalog',NULL,86,NULL,NULL,NULL,1,'2026-08-15 02:37:09','2026-09-05 18:09:37'),(1521,1520,'ProviderApplicationAudit','/provider-admin/applications','/system/provider/applications',NULL,NULL,'审核中心','mdi:clipboard-check-outline','menu','Provider:Admin:Application:List',10,NULL,NULL,NULL,1,'2026-08-15 02:37:09','2026-10-11 23:22:28'),(1522,1520,'ProviderAdminList','/provider-admin/list','/system/provider/list',NULL,NULL,'menu.providerAdmin.list','mdi:store-outline','menu','Provider:Admin:List',20,NULL,NULL,NULL,1,'2026-08-15 02:37:09','2026-09-05 18:09:37'),(1523,1522,'ProviderAdminCommission','/provider-admin/list/commission',NULL,NULL,NULL,'调抽成',NULL,'button','Provider:Admin:Commission',21,NULL,NULL,1,1,'2026-08-15 02:37:09','2026-08-15 02:37:09'),(1524,1522,'ProviderAdminFreeze','/provider-admin/list/freeze',NULL,NULL,NULL,'冻结解冻',NULL,'button','Provider:Admin:Freeze',22,NULL,NULL,1,1,'2026-08-15 02:37:09','2026-08-15 02:37:09'),(1600,0,'TicketCenter','/ticket',NULL,NULL,'/ticket/list','menu.ticket.home','mdi:ticket-outline','catalog',NULL,0,NULL,NULL,NULL,1,'2026-08-20 00:10:50','2026-10-21 20:22:14'),(1601,1600,'TicketMine','/ticket/list','/ticket/list',NULL,NULL,'menu.ticket.mine','mdi:ticket-outline','menu','Ticket:List',1,NULL,NULL,NULL,1,'2026-10-21 20:22:14','2026-10-21 20:22:14'),(1602,1600,'TicketAdmin','/ticket/admin','/ticket/admin',NULL,NULL,'menu.ticket.admin','mdi:ticket-confirmation-outline','menu','Ticket:Admin:List',2,NULL,NULL,NULL,1,'2026-08-20 00:11:05','2026-09-05 18:46:40'),(1603,1600,'TicketProvider','/provider/ticket','/provider/ticket',NULL,NULL,'menu.ticket.provider','mdi:ticket-confirmation-outline','menu','Ticket:Provider:*',3,NULL,NULL,NULL,1,'2026-08-20 00:11:05','2026-09-05 18:09:37'),(1613,1600,'TicketTypeConfig','/ticket/type','/ticket/type/list',NULL,NULL,'menu.ticket.types','mdi:format-list-bulleted-type','menu',NULL,40,NULL,NULL,NULL,1,'2026-08-24 21:37:31','2026-09-05 18:09:37'),(1700,0,'ReferralCenter','/referral',NULL,NULL,NULL,'menu.promote.title','mdi:account-group-outline','catalog',NULL,0,NULL,NULL,NULL,1,'2026-08-20 00:11:37','2026-09-05 18:09:37'),(1701,1700,'ReferralIndex','/referral/index','/referral/index',NULL,NULL,'menu.promote.inviteCode','mdi:ticket-confirmation-outline','menu','Referral:Index',1,NULL,NULL,NULL,1,'2026-08-20 00:11:37','2026-09-05 18:09:37'),(1702,1700,'ReferralCommissions','/referral/commissions','/referral/commissions',NULL,NULL,'menu.promote.commission','mdi:cash-multiple','menu','Referral:Commissions',2,NULL,NULL,NULL,1,'2026-08-20 00:11:37','2026-09-05 18:09:37'),(1703,1700,'ReferralWithdraw','/referral/withdraw','/referral/withdraw',NULL,NULL,'menu.promote.withdraw','mdi:wallet-outline','menu','Referral:Withdraw',3,NULL,NULL,NULL,1,'2026-08-20 00:11:37','2026-09-05 18:09:37'),(1705,1700,'ReferralWithdrawAdmin','/referral/withdraw-admin','/referral/withdraw-admin',NULL,NULL,'menu.promote.withdrawAudit','mdi:clipboard-check-outline','menu','Referral:Withdraw:Admin',5,NULL,NULL,NULL,1,'2026-08-20 00:11:37','2026-09-05 18:09:37'),(1800,0,'MemberLevelCenter','/member-level',NULL,NULL,'/member-level/my','menu.member.title','mdi:medal-outline','catalog',NULL,82,NULL,NULL,NULL,1,'2026-08-24 19:57:37','2026-09-05 18:09:37'),(1801,1800,'MyLevel','/member-level/my','/user/level',NULL,NULL,'menu.member.myLevel','mdi:medal','menu',NULL,10,NULL,NULL,NULL,1,'2026-08-24 19:57:37','2026-09-05 18:09:37'),(1802,1800,'MemberLevelConfig','/member-level/config','/member-level/list',NULL,NULL,'等级与经验','mingcute:flash-line','menu',NULL,20,NULL,NULL,NULL,1,'2026-08-24 19:57:37','2026-09-19 01:48:19'),(1803,1800,'MemberLevelLogs','/member-level/logs','/member-level/logs',NULL,NULL,'menu.member.growthDetail','mdi:file-document-outline','menu',NULL,30,NULL,NULL,NULL,1,'2026-08-24 19:57:37','2026-09-05 18:09:37'),(1900,0,'SignInCenter','/sign-in',NULL,NULL,'/sign-in/index','menu.sign.title','mdi:calendar-check-outline','catalog',NULL,84,NULL,NULL,NULL,1,'2026-08-24 19:57:37','2026-09-05 18:09:37'),(1901,1900,'SignInIndex','/sign-in/index','/sign-in/index',NULL,NULL,'menu.sign.daily','mdi:calendar-check','menu',NULL,10,NULL,NULL,NULL,1,'2026-08-24 19:57:37','2026-09-05 18:09:37'),(1902,1900,'SignInConfig','/sign-in/config','/sign-in/config',NULL,NULL,'menu.sign.config','mdi:cog-outline','menu',NULL,20,NULL,NULL,NULL,1,'2026-08-24 19:57:37','2026-09-05 18:09:37'),(2001,0,'UserOperationLog','/user/operation-log','/user/operation-log',NULL,NULL,'menu.log.mine','mdi:history','menu',NULL,85,NULL,NULL,NULL,1,'2026-08-24 21:37:31','2026-09-05 18:09:37'),(2010,200,'SystemOperationLog','/system/operation-log','/system/operation-log/index',NULL,NULL,'操作日志','mdi:text-box-search-outline','menu',NULL,50,NULL,NULL,NULL,1,'2026-08-24 21:37:31','2026-09-19 02:14:20'),(2012,200,'IpBlacklist','/system/ip-blacklist','/system/ip-blacklist/index',NULL,NULL,'menu.security.ipBlacklist','mdi:account-lock-outline','menu',NULL,70,NULL,NULL,NULL,1,'2026-08-25 16:38:07','2026-09-05 18:09:37'),(2013,200,'IpBlockLog','/system/ip-block-log','/system/ip-block-log/index',NULL,NULL,'menu.security.ipBlockLog','mdi:shield-lock-outline','menu',NULL,71,NULL,NULL,NULL,1,'2026-08-25 16:38:07','2026-09-05 18:46:40'),(2014,1500,'SqlDatasource','/provider/sql-datasource','/provider/sql-datasource/index',NULL,NULL,'menu.sql.datasource','mdi:database-outline','menu','Provider:SqlDatasource:List',15,NULL,NULL,NULL,1,'2026-08-25 20:01:33','2026-09-05 18:09:37'),(2015,1500,'SqlApiList','/provider/sql-apis','/provider/sql-api/index',NULL,NULL,'menu.sql.interface','mdi:code-brackets','menu','Provider:SqlApi:List',16,NULL,NULL,NULL,1,'2026-08-25 20:01:33','2026-09-05 18:09:37'),(2016,200,'SqlApiConfig','/system/sql-api-config','/system/sql-api-config/index',NULL,NULL,'menu.sql.config','mdi:tune-vertical','menu','Admin:SqlApiConfig:Update',70,NULL,NULL,NULL,1,'2026-08-25 20:01:33','2026-09-05 18:09:37'),(2017,0,'InterfaceUsage','/interface/usage','/interface/usage/index',NULL,NULL,'menu.statistics.usage','mdi:chart-areaspline','menu','Interface:Usage:View',8,NULL,NULL,NULL,1,'2026-08-26 19:33:49','2026-09-05 18:09:37'),(2018,1500,'ProviderRevenue','/provider/revenue','/provider/revenue/index',NULL,NULL,'menu.income.detail','mdi:currency-cny','menu','Provider:Revenue:View',17,NULL,NULL,NULL,1,'2026-08-26 19:33:49','2026-09-05 18:09:37'),(2020,200,'CustomPage','/custom-page','/custom-page/list',NULL,NULL,'menu.customPage.title','mdi:file-document-edit-outline','menu','CustomPage:List',80,NULL,NULL,NULL,1,'2026-08-29 14:13:41','2026-09-05 19:57:28'),(2030,0,'HelpDocManagement','/help-doc',NULL,NULL,'/help-doc/article','menu.helpDoc.title','mingcute:book-5-line','catalog',NULL,62,NULL,NULL,NULL,1,'2026-09-05 17:34:47','2026-09-29 23:29:54'),(2032,2030,'HelpDocArticle','/help-doc/article','/help-doc/article/list',NULL,NULL,'menu.helpDoc.article','mingcute:file-line','menu',NULL,20,NULL,NULL,NULL,1,'2026-09-05 17:34:47','2026-09-05 18:46:40'),(2040,0,'HomeNewsManagement','/home-news',NULL,NULL,'/home-news/item','menu.homeNews.title','mdi:newspaper-variant-outline','catalog',NULL,63,NULL,NULL,NULL,1,'2026-09-05 19:38:39','2026-10-11 23:22:28'),(2042,2040,'HomeNewsItem','/home-news/item','/home-news/item/list',NULL,NULL,'menu.homeNews.item','mdi:file-document-multiple-outline','menu',NULL,20,NULL,NULL,NULL,1,'2026-09-05 19:38:39','2026-10-11 23:22:28'),(2050,200,'SystemLoginLog','/system/login-log','/system/login-log/index',NULL,NULL,'menu.log.login','mdi:login','menu','System:LoginLog',61,NULL,NULL,NULL,1,'2026-09-06 17:48:55','2026-09-06 17:48:55'),(2051,200,'SystemDict','/system/dict','/system/dict/index',NULL,NULL,'menu.system.dict','mdi:book-alphabet','menu','System:Dict',62,NULL,NULL,NULL,1,'2026-09-06 17:48:55','2026-09-06 17:48:55'),(2052,200,'FeatureSwitch','/system/feature-switch','/system/feature-switch/index',NULL,NULL,'menu.system.featureSwitch','mdi:tune-vertical','menu','System:FeatureSwitch',63,NULL,NULL,NULL,1,'2026-09-06 23:38:26','2026-09-07 01:01:07'),(2053,200,'MessageTemplate','/system/message-template','/system/message-template/index',NULL,NULL,'站内信','mdi:message-text-outline','menu',NULL,64,NULL,NULL,NULL,1,'2026-09-14 17:18:37','2026-09-14 17:18:37'),(2061,0,'UserBill','/user/bill','/user/bill',NULL,NULL,'menu.bill.title','mdi:receipt-text-outline','menu',NULL,65,NULL,NULL,NULL,1,'2026-09-07 20:20:00','2026-09-07 20:20:00'),(2080,200,'SystemResource','/system/resource','/system/resource/index',NULL,NULL,'system.resource.title','mdi:shield-key-outline','menu',NULL,70,NULL,NULL,NULL,1,'2026-09-08 22:34:39','2026-09-08 22:35:01'),(2100,0,'SecurityManagement','/system/security',NULL,NULL,'/system/security/password-policy','安全管理','mdi:shield-account-outline','catalog',NULL,95,NULL,NULL,NULL,1,'2026-09-09 03:05:22','2026-09-09 03:05:22'),(2101,2100,'SecurityPasswordPolicy','/system/security/password-policy','/system/security/password-policy/index',NULL,NULL,'密码策略','mdi:form-textbox-password','menu','Security:PasswordPolicy',10,NULL,NULL,NULL,1,'2026-09-09 03:05:22','2026-09-09 03:05:22'),(2102,2100,'SecurityAuthFlow','/system/security/auth-flow','/system/security/auth-flow/index',NULL,NULL,'认证流配置','mdi:routes','menu','Security:AuthFlow',20,NULL,NULL,NULL,1,'2026-09-09 03:05:22','2026-10-11 23:22:28'),(2103,2100,'SecurityConfig','/system/security/config','/system/security/config/index',NULL,NULL,'安全配置','mdi:shield-lock-outline','menu','Security:Config',30,NULL,NULL,NULL,1,'2026-09-09 03:05:22','2026-10-11 23:22:28'),(2104,2100,'SecurityOauthClient','/system/security/oauth-client','/system/security/oauth-client/index',NULL,NULL,'OAuth 客户端','mdi:key-chain-variant','menu','Security:OauthClient',40,NULL,NULL,NULL,1,'2026-09-09 03:05:22','2026-09-09 03:05:22'),(2110,0,'ContentCenterManagement','/content-center',NULL,NULL,NULL,'menu.contentCenter.title','mingcute:layout-line','menu',NULL,61,0,0,NULL,1,'2026-09-10 19:51:58','2026-09-10 21:36:51'),(2111,2110,'ContentItemList','/content-center/item','/content-center/item/list',NULL,NULL,'menu.contentCenter.item','mdi:format-list-bulleted','menu','Content:Item:List',10,0,0,NULL,1,'2026-09-10 19:51:58','2026-10-11 23:22:28'),(2115,2110,'ContentImportIndex','/content-center/import','/content-center/import/index',NULL,NULL,'menu.contentCenter.import','mingcute:upload-line','menu','Content:Import:Manage',50,0,0,NULL,1,'2026-09-10 21:47:39','2026-09-10 21:47:39'),(2116,2110,'ContentCollectIndex','/content-center/collect','/content-center/collect/index',NULL,NULL,'menu.contentCenter.collect','mingcute:link-line','menu','Content:Collect:Manage',60,0,0,NULL,1,'2026-09-10 21:47:39','2026-09-10 21:47:39'),(2130,0,'ScheduleTaskManagement','/schedule-task',NULL,NULL,NULL,'menu.scheduleTask.title','mingcute:time-line','menu',NULL,84,0,0,NULL,1,'2026-09-10 19:51:58','2026-09-10 21:36:51'),(2131,2130,'ScheduleTaskList','/schedule-task/list','/schedule-task/list',NULL,NULL,'menu.scheduleTask.list','mingcute:calendar-line','menu','Schedule:Task:List',10,0,0,NULL,1,'2026-09-10 19:51:58','2026-09-10 21:36:51'),(2140,900,'商户管理','/payment/merchant','/payment/merchant/index',NULL,NULL,'商户管理','mingcute:store-2-line','menu',NULL,7,NULL,NULL,NULL,1,'2026-09-17 00:15:05','2026-09-17 00:15:05'),(2142,1700,'自动化管理','/growth/automation','/growth/automation/index',NULL,NULL,'自动化管理','mingcute:robot-line','menu',NULL,10,NULL,NULL,NULL,1,'2026-09-17 00:15:05','2026-09-17 00:15:05'),(2145,1800,'徽章管理','/growth/badge','/growth/badge/index',NULL,NULL,'徽章管理','mingcute:award-line','menu',NULL,8,NULL,NULL,NULL,1,'2026-09-17 00:15:05','2026-09-17 00:15:05'),(2146,200,'Webhook 订阅','/system/webhook-subscription','/system/webhook-subscription/index',NULL,NULL,'Webhook 订阅','mingcute:webhook-line','menu',NULL,30,NULL,NULL,NULL,1,'2026-09-17 00:15:05','2026-09-17 00:15:05'),(2147,1500,'接口健康','/provider/health','/provider/health-dashboard',NULL,NULL,'接口健康','mdi:heart-pulse','menu',NULL,12,NULL,NULL,NULL,1,'2026-09-17 00:15:05','2026-09-30 01:34:13'),(2148,500,'我的订阅','/interface/my-subscriptions','/interface/subscription/my-subscriptions',NULL,NULL,'我的订阅','mdi:credit-card-settings-outline','menu',NULL,12,NULL,NULL,NULL,1,'2026-09-17 00:15:05','2026-10-11 23:22:28'),(9010,100,'dashboard-center','/dashboard-center','system/dashboard-center/index',NULL,NULL,'看板中心','mdi:view-dashboard-outline','menu',NULL,20,NULL,NULL,NULL,1,'2026-09-11 03:25:02','2026-10-11 23:22:28'),(9011,200,'monitor-center','/monitor-center','system/monitor-center/index',NULL,NULL,'监控中心','mdi:monitor-dashboard','menu',NULL,85,NULL,NULL,NULL,1,'2026-09-11 03:25:02','2026-10-11 23:22:34'),(9012,200,'alert-center','/alert-center','system/alert-center/index',NULL,NULL,'告警中心','mdi:bell-outline','menu',NULL,86,NULL,NULL,NULL,1,'2026-09-11 03:25:02','2026-10-11 23:22:28'),(9200,0,'tenant','/tenant','tenant/index',NULL,NULL,'我的租户','mdi:account-group-outline','menu',NULL,45,NULL,NULL,NULL,1,'2026-09-15 23:33:26','2026-10-11 23:22:28'),(9210,0,'tenant-admin','/tenant-admin',NULL,NULL,NULL,'租户计费','mdi:office-building-outline','catalog',NULL,86,NULL,NULL,NULL,1,'2026-09-15 23:33:26','2026-10-11 23:22:28'),(9211,9210,'tenant-list','/tenant-admin/list','tenant-admin/index',NULL,NULL,'租户管理','mdi:card-account-details-outline','menu',NULL,1,NULL,NULL,NULL,1,'2026-09-15 23:33:26','2026-10-11 23:22:28'),(9212,9210,'tenant-plans','/tenant-admin/plans','tenant-admin/plans',NULL,NULL,'订阅计划','mingcute:calendar-line','menu',NULL,2,NULL,NULL,NULL,1,'2026-09-15 23:33:26','2026-09-17 00:14:40'),(9213,9210,'tenant-bills','/tenant-admin/bills','tenant-admin/bills',NULL,NULL,'租户账单','mingcute:bill-line','menu',NULL,3,NULL,NULL,NULL,1,'2026-09-15 23:33:26','2026-09-17 00:14:40'),(9214,9210,'tenant-outbox','/tenant-admin/outbox','tenant-admin/outbox',NULL,NULL,'Outbox 监控','mingcute:send-line','menu',NULL,4,NULL,NULL,NULL,1,'2026-09-15 23:33:26','2026-09-17 00:14:40'),(9215,254,'QuickLoginLegacy','/login-manage/quick',NULL,NULL,'/login-manage/third-party','快捷登录(旧链接)',NULL,'menu',NULL,11,NULL,NULL,1,1,'2026-09-29 23:40:27','2026-09-29 23:40:27'),(9216,2030,'HelpDocCategoryLegacy','/help-doc/category',NULL,NULL,'/help-doc/article','文档分类(旧链接)',NULL,'menu',NULL,21,NULL,NULL,1,1,'2026-09-29 23:40:27','2026-09-29 23:40:27');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (1,100),(1,101),(1,102),(2,102),(1,200),(1,201),(1,202),(1,204),(1,205),(1,206),(1,207),(1,208),(1,209),(1,211),(1,212),(1,250),(1,251),(1,254),(1,255),(1,256),(1,257),(1,301),(2,301),(1,400),(1,401),(1,402),(1,403),(1,404),(1,500),(1,501),(1,502),(1,503),(1,504),(1,505),(2,505),(1,507),(1,508),(1,600),(2,600),(2,601),(2,602),(2,603),(2,604),(2,605),(1,700),(1,701),(1,703),(1,704),(1,705),(1,709),(1,800),(2,800),(1,801),(2,801),(1,802),(2,802),(1,803),(2,803),(1,804),(2,804),(1,805),(2,805),(1,900),(1,901),(1,902),(1,903),(1,904),(1,905),(1,906),(1,907),(1,908),(1,909),(1,910),(1,911),(1,1000),(1,1001),(1,1002),(1,1003),(1,1004),(1,1005),(1,1006),(1,1007),(2,1007),(3,1007),(1,1008),(1,1009),(1,1100),(1,1101),(1,1102),(1,1103),(1,1104),(1,1105),(1,1110),(1,1111),(1,1112),(1,1113),(1,1200),(1,1201),(1,1202),(1,1203),(1,1204),(1,1300),(1,1301),(1,1400),(1,1401),(1,1402),(1,1403),(1,1500),(2,1500),(3,1500),(1,1501),(2,1501),(1,1502),(3,1502),(1,1503),(3,1503),(1,1504),(3,1504),(1,1505),(3,1505),(1,1506),(3,1506),(1,1507),(3,1507),(1,1508),(3,1508),(1,1509),(3,1509),(1,1520),(1,1521),(1,1522),(1,1523),(1,1524),(1,1600),(2,1600),(3,1600),(1,1601),(2,1601),(3,1601),(1,1602),(1,1603),(3,1603),(1,1613),(1,1700),(2,1700),(1,1701),(2,1701),(1,1702),(2,1702),(1,1703),(2,1703),(1,1705),(1,1800),(2,1800),(3,1800),(1,1801),(2,1801),(3,1801),(1,1802),(1,1803),(1,1900),(2,1900),(1,1901),(2,1901),(1,1902),(1,2001),(2,2001),(1,2010),(1,2012),(1,2013),(1,2014),(3,2014),(1,2015),(3,2015),(1,2016),(1,2017),(2,2017),(1,2018),(3,2018),(1,2020),(1,2030),(1,2032),(1,2040),(1,2042),(1,2050),(1,2051),(1,2052),(1,2053),(1,2061),(2,2061),(1,2080),(1,2100),(1,2101),(1,2102),(1,2103),(1,2104),(1,2110),(1,2111),(1,2115),(1,2116),(1,2130),(1,2131),(1,2140),(1,2142),(1,2145),(1,2146),(1,2147),(1,2148),(1,9010),(1,9011),(1,9012),(1,9200),(2,9200),(1,9210),(1,9211),(1,9212),(1,9213),(1,9214),(1,9215),(1,9216);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_feature_switch` WRITE;
/*!40000 ALTER TABLE `sys_feature_switch` DISABLE KEYS */;
INSERT INTO `sys_feature_switch` VALUES (1,'redeem_card_enabled','兑换卡生成与兑换','控制兑换卡生成与用户兑换功能。关闭后停止发新卡与核销，兑换活动异常时紧急止血。','FUND',1,101,'zhengxian','2026-09-06 23:38:26','2026-09-18 17:30:31',100),(2,'package_purchase_enabled','套餐商城购买','控制用户是否可下单购买全局套餐与接口套餐。关闭后商城不可下单，调价或库存盘点时使用。','FUND',1,102,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(3,'withdraw_apply_enabled','佣金提现申请','控制用户能否提交佣金提现申请。关闭后提现入口停止受理，风控冻结期使用。','FUND',1,103,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(4,'recharge_order_enabled','充值与套餐下单','控制充值订单与套餐支付订单的创建。关闭后停止创建新支付订单，支付渠道故障期使用。','FUND',1,104,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(5,'commission_settle_enabled','佣金结算跑批','控制每日 2:00 佣金结算跑批是否执行。关闭后佣金结算暂停，佣金争议处理期冻结分账。','FUND',1,105,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(6,'provider_statement_enabled','服务商月度对账单','控制每月 1 日 3:00 服务商月度对账单生成。关闭后暂停出账，对账规则调整期使用。','FUND',1,106,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(7,'payment_retry_enabled','支付失败重试跑批','控制支付到账重试补偿跑批。关闭后暂停重试，在途订单需人工确认处理。','FUND',1,107,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(8,'refund_enabled','管理端退款','控制管理端发起退款与手动同步退款状态。关闭后退款出口冻结，渠道对账异常期使用。','FUND',1,108,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(9,'settlement_reversal_enabled','结算冲正','控制佣金与服务费的结算冲正操作。关闭后冲正入口停止，财务审计期防止误操作。','FUND',1,109,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(10,'order_expire_close_enabled','订单过期自动关闭','控制过期待支付订单是否自动关闭（每 60 秒扫描）。关闭后待支付订单长期有效，促销期延长支付窗口。','FUND',1,110,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(11,'refund_sync_enabled','退款状态自动同步','控制处理中退款的结果自动轮询同步（每 120 秒）。关闭后退款需手动同步，支付渠道维护期使用。','FUND',1,111,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(12,'gateway_invoke_enabled','开放 API 网关调用','平台级维护总开关。关闭后所有开放 API 调用返回维护提示，升级或重大故障整体维护时使用。','GATEWAY',1,201,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(13,'console_invoke_enabled','控制台在线调试','控制用户能否在控制台在线调用接口调试。关闭后在线调试停止，防止刷上游接口。','GATEWAY',1,202,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(14,'billing_enabled','网关计费','控制 API 调用是否计费扣费。关闭后调用不计费不结算，仅限内部测试或故障豁免期使用，慎开！','GATEWAY',1,203,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(15,'market_enabled','API 市场展示','控制前台 API 市场页面可见性。关闭后市场隐藏只下架不删数据。','GATEWAY',1,204,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(16,'stats_dashboard_enabled','数据看板与统计','控制统计看板实时聚合查询。关闭后统计降载，数据库压力大时使用。','GATEWAY',1,205,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(17,'sql_api_debug_enabled','SQL API 在线调试','控制服务商能否在线执行 SQL 调试。关闭后 SQL 调试入口停止，数据抽查巡检期使用。','GATEWAY',1,206,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(18,'password_change_enabled','修改密码','控制用户能否自助修改密码。关闭后改密走管理员处理，账号异常排查期使用。','USER',1,301,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(19,'password_reset_enabled','找回密码','控制邮箱验证码找回密码。关闭后忘记密码走人工申诉通道。','USER',1,302,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(20,'refresh_token_enabled','双 Token 刷新','控制 refreshToken 刷新机制。关闭后仅单 access token 模式，安全演练排查期使用。','USER',1,303,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(21,'session_manage_enabled','管理员强制下线','控制管理员强制踢用户下线能力。关闭后停用强制下线，防止误操作批量踢人。','USER',1,304,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(22,'login_rate_limit_enabled','登录限流与锁定','控制登录限流与失败锁定（20次/分、100次/时、5次失败锁定）。关闭后登录不再限流，仅建议短期排查使用。','USER',1,305,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(23,'operation_log_enabled','操作审计日志','控制用户操作日志记录。关闭后停止写操作日志，合规期不建议关闭。','USER',1,306,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(24,'register_verify_required','注册需激活','开启后新注册账号需管理员激活后才能登录；关闭后注册直接激活。','USER',0,307,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(25,'profile_edit_enabled','个人资料编辑','控制用户编辑资料与绑定邮箱手机。关闭后资料只读，数据治理冻结期使用。','USER',1,308,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(26,'upload_enabled','图片上传','控制全站图片上传。关闭后停止上传，存储故障或内容审查期使用。','USER',1,309,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(27,'invite_code_enabled','邀请码返佣','控制注册时邀请码返佣绑定。关闭后注册不再支持邀请码。','USER',1,310,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(28,'member_level_enabled','成长值与等级','控制成长值等级体系运行。关闭后停止发放经验值，等级冻结。','USER',1,311,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(29,'api_key_manage_enabled','API Key 管理','控制用户创建与重置 API Key。关闭后 Key 操作停止，密钥泄露处置期使用。','USER',1,312,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(30,'session_self_manage_enabled','用户自助设备管理','控制用户自助踢其他设备下线。关闭后自助管理多端会话停止，安全策略调整期使用。','USER',1,313,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(31,'email_send_enabled','邮件发送','控制是否真实发送邮件。关闭后 SMTP 不实际发信（注册验证码邮件跳过），SMTP 故障或欠费时防止流程卡死。','NOTIFY',1,401,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(32,'sms_send_enabled','短信发送','控制阿里云短信发送。关闭后短信通道停止，通道维护期使用。','NOTIFY',1,402,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(33,'provider_apply_enabled','服务商入驻申请','控制新服务商入驻申请受理。关闭后停止入驻，供应商饱和期使用。','CONTENT',1,501,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(34,'ticket_enabled','工单系统','控制新建与回复工单。关闭后工单提交停止，客服系统切换迁移期使用。','CONTENT',1,502,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(35,'help_doc_enabled','帮助文档中心','控制前台帮助文档中心可见性。关闭后文档中心隐藏，内容重构期使用。','CONTENT',1,503,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(36,'custom_page_enabled','自定义页面','自定义页面总开关。关闭后全部动态 DSL 页面停止服务（单页自身状态独立控制）。','CONTENT',1,504,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(37,'faq_enabled','FAQ 常见问题','控制前台 FAQ 模块可见性。关闭后 FAQ 隐藏。','CONTENT',1,505,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(38,'glossary_public_enabled','术语词典公开接口','控制帮助文档页术语弹窗。关闭后术语词典停用，词典维护期使用。','CONTENT',1,506,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(39,'home_news_enabled','新闻资讯','控制前台新闻资讯模块整体可见性。关闭后新闻隐藏，比逐条停用更方便。','CONTENT',1,507,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(40,'provider_directory_enabled','服务商目录展示','控制前台服务商目录、店铺页与排行榜可见性。关闭后服务商展示入口全部隐藏。','CONTENT',1,508,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(41,'home_overview_enabled','首页数据聚合','控制首页统计卡片实时聚合查询。关闭后首页统计降载，大促压测期使用。','CONTENT',1,509,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(42,'member_message_enabled','会员消息中心','控制用户消息中心查询与已读。关闭后消息中心停用，消息模板重构期使用。','CONTENT',1,510,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(43,'ip_log_cleanup_enabled','IP 封禁日志清理','控制每日 3:30 IP 封禁日志清理跑批。关闭后暂停清理保留更多历史记录。','TASK',1,601,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(44,'ticket_sla_enabled','工单 SLA 升级','控制每小时工单超时自动升级跑批。关闭后工单不再自动升级，SLA 规则调整期使用。','TASK',1,602,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(45,'ticket_autoclose_enabled','工单自动关闭','控制每日 2:00 待反馈工单自动关闭跑批。关闭后待反馈工单不自动关闭。','TASK',1,603,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(46,'access_log_enabled','访问日志记账','控制接口调用日志记录。关闭后停止写调用日志降低高流量负载（计费独立不受影响）。','TASK',1,604,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(47,'ip_blacklist_enabled','IP 黑名单拦截','控制 IP 黑名单规则匹配拦截。关闭后黑名单不再拦截，排查误封时使用。','TASK',1,605,'zhengxian','2026-09-06 23:38:26','2026-09-14 21:33:58',100),(95,'sign_in_enabled','签到功能','控制签到活动是否启用。关闭后签到入口停用，用户无法每日签到领取奖励。','CONTENT',1,701,'zhengxian','2026-09-07 00:48:00','2026-09-14 21:33:58',100),(96,'sign_in_makeup_enabled','签到允许补签','控制是否允许用户补签漏签的日期。关闭后补签入口停用，仅可签到当天。','CONTENT',1,702,'zhengxian','2026-09-07 00:48:00','2026-09-14 21:33:58',100),(97,'register_open_enabled','开放注册','控制前台是否开放自助注册。关闭后注册入口停用，只能由管理员添加入驻。','USER',1,703,'zhengxian','2026-09-07 00:48:00','2026-09-14 21:33:58',100),(98,'email_register_enabled','邮箱注册配置','控制按 SMTP 配置发送注册邮箱验证码。关闭后邮箱验证码通道停用，注册不再发信。','NOTIFY',1,704,'zhengxian','2026-09-07 00:48:00','2026-09-14 21:33:58',100),(99,'sms_register_enabled','短信注册配置','控制按阿里云短信配置发送注册手机验证码。关闭后短信验证码通道停用，注册不再下发。','NOTIFY',0,705,'zhengxian','2026-09-07 00:48:00','2026-09-14 21:33:58',100),(100,'alipay_channel_enabled','支付宝支付渠道','控制支付宝渠道是否可用于充值支付。关闭后充值页不展示支付宝付款方式。','FUND',1,706,'zhengxian','2026-09-07 00:48:00','2026-09-14 21:33:58',100),(101,'wechat_channel_enabled','微信支付渠道','控制微信渠道是否可用于充值支付。关闭后充值页不展示微信付款方式。','FUND',0,707,'zhengxian','2026-09-07 00:48:00','2026-09-14 21:33:58',100),(102,'home_notice_enabled','首页滚动公告','控制首页顶部滚动公告条是否展示。关闭后滚动公告隐藏，内容仍可编辑。','CONTENT',1,708,'zhengxian','2026-09-07 00:48:00','2026-09-14 21:33:58',100),(103,'friend_link_apply_enabled','友链申请入口','控制用户能否提交友情链接申请。关闭后申请入口停用，已上架友链不受影响。','CONTENT',1,709,'zhengxian','2026-09-07 00:48:00','2026-09-14 21:33:58',100),(152,'access_log_cleanup_enabled','调用日志清理','控制用户调用日志每日自动清理跑批。关闭后暂停清理，历史日志按原保留天数留存。','TASK',1,711,'zhengxian','2026-09-07 01:01:07','2026-09-20 04:19:49',100),(153,'point_exchange_enabled','积分兑换套餐','控制用户使用点数兑换全站/接口套餐。关闭后兑换入口停止受理，已开通套餐与点数余额不受影响。','FUND',1,112,'zhengxian','2026-09-07 20:18:56','2026-09-14 21:33:58',100),(154,'referral_two_level_enabled','二级返佣','控制佣金结算是否产生二级推荐人佣金。关闭后新结算仅保留一级，属地合规收紧时降级使用。','FUND',1,112,'zhengxian','2026-09-07 20:18:56','2026-09-14 21:33:58',100),(155,'monitor_enabled','服务可用性监控','HTTP/TCP/DNS/PING 定时探测 + 心跳历史','TASK',1,50,NULL,'2026-09-11 01:29:33','2026-09-11 01:29:33',100),(156,'notification_channel_enabled','通知渠道抽象','Webhook/邮件/飞书统一告警通道','NOTIFY',1,51,NULL,'2026-09-11 01:29:33','2026-09-11 01:29:33',100),(157,'chart_type_registry_enabled','插件式图表注册','ChartTypeRegistry 注册 handler 不改主链路','CONTENT',1,52,NULL,'2026-09-11 01:29:33','2026-09-11 01:29:33',100),(158,'dashboard_dataset_enabled','数据集抽象','SQL/API/STATIC 三模式查询模型','CONTENT',1,53,NULL,'2026-09-11 01:29:33','2026-09-11 01:29:33',100),(159,'dashboard_layout_enabled','看板布局自定义','JSON 布局 + 卡片拖拽编辑','CONTENT',1,54,NULL,'2026-09-11 01:29:33','2026-09-11 01:29:33',100),(160,'log_archive_enabled','日志归档与清理','月度归档 + 主表保留90天 + Excel导出','TASK',1,55,NULL,'2026-09-11 01:29:33','2026-09-11 01:29:33',100),(161,'dashboard_cache_enabled','统计接口Redis缓存','300s 定时刷新 + 防击穿','GATEWAY',1,56,NULL,'2026-09-11 01:29:33','2026-09-11 01:29:33',100),(162,'system_monitor_enabled','系统监控面板','CPU/内存/磁盘/JVM/运行时长','GATEWAY',1,57,NULL,'2026-09-11 01:29:33','2026-09-11 01:29:33',100),(163,'alert_engine_enabled','平台健康告警引擎','For防抖状态机 + 分级 + 静默','GATEWAY',1,58,NULL,'2026-09-11 01:29:33','2026-09-11 01:29:33',100),(164,'report_template_enabled','报表单元格模型','按配置导出Excel','CONTENT',1,59,NULL,'2026-09-11 01:29:33','2026-09-11 01:29:33',100),(166,'growth_analytics_enabled','增长分析报表','漏斗/留存/渠道 ROI 报表','GATEWAY',1,70,NULL,'2026-09-13 20:40:26','2026-09-13 20:40:26',100),(167,'email_campaign_enabled','营销邮件活动','批量邮件活动与断点续发','GATEWAY',1,71,NULL,'2026-09-13 20:40:26','2026-09-13 20:40:26',100),(168,'user_segment_enabled','用户分群','条件圈人与分群动作','GATEWAY',1,72,NULL,'2026-09-13 20:40:26','2026-09-13 20:40:26',100),(169,'growth_experiment_enabled','A/B 实验','分流与实验报表','GATEWAY',1,73,NULL,'2026-09-13 20:40:26','2026-09-13 20:40:26',100),(170,'sql_api_publish_approve_required','SQL接口发布审批流','开启后发布草稿须先提交审批，管理员通过后自动覆盖发布；关闭时保留直接发布行为','GATEWAY',0,60,NULL,'2026-09-17 02:31:26','2026-09-17 02:31:26',100);
/*!40000 ALTER TABLE `sys_feature_switch` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_dict` WRITE;
/*!40000 ALTER TABLE `sys_dict` DISABLE KEYS */;
INSERT INTO `sys_dict` VALUES (1,'package_order_status','套餐订单状态',1,'套餐订单状态展示','2026-09-06 17:48:55','2026-09-06 17:48:55'),(2,'interface_status','接口状态',1,'接口上下架状态展示','2026-09-06 17:48:55','2026-09-06 17:48:55');
/*!40000 ALTER TABLE `sys_dict` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_dict_item` WRITE;
/*!40000 ALTER TABLE `sys_dict_item` DISABLE KEYS */;
INSERT INTO `sys_dict_item` VALUES (1,'package_order_status','待支付','PENDING',1,1,'2026-09-06 17:48:55','2026-09-06 17:48:55'),(2,'package_order_status','已支付','PAID',2,1,'2026-09-06 17:48:55','2026-09-06 17:48:55'),(3,'package_order_status','支付失败','FAILED',3,1,'2026-09-06 17:48:55','2026-09-06 17:48:55'),(4,'package_order_status','已关闭','CLOSED',4,1,'2026-09-06 17:48:55','2026-09-06 22:23:45'),(8,'interface_status','已上架','1',1,1,'2026-09-06 17:48:55','2026-09-18 23:08:07'),(9,'interface_status','已下架','0',2,1,'2026-09-06 17:48:55','2026-09-18 23:08:07'),(10,'interface_status','弃用中','3',3,1,'2026-09-06 17:48:55','2026-09-18 23:08:07'),(95,'interface_status','已退役','4',4,1,'2026-09-18 23:08:07','2026-09-18 23:08:07');
/*!40000 ALTER TABLE `sys_dict_item` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_captcha_config` WRITE;
/*!40000 ALTER TABLE `sys_captcha_config` DISABLE KEYS */;
INSERT INTO `sys_captcha_config` VALUES (1,'POW','2026-10-13 14:34:53',3);
/*!40000 ALTER TABLE `sys_captcha_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_security_config` WRITE;
/*!40000 ALTER TABLE `sys_security_config` DISABLE KEYS */;
INSERT INTO `sys_security_config` VALUES ('cas.service.whitelist','','CAS 允许的 service 回调地址，逗号分隔；条目以/结尾按前缀匹配，否则全等匹配，为空则拒绝所有','2026-09-09 03:05:20'),('mfa.email.content','您的验证码为 {code}，5分钟内有效。','MFA邮箱验证码邮件模板，{code}为占位符','2026-09-09 03:05:20'),('mfa.email.title','正贤Api安全验证码','MFA邮箱验证码邮件标题','2026-09-14 19:07:45'),('payment.card-order','[]','支付卡片展示顺序（按添加先后）','2026-10-18 17:10:21'),('third-party.alipay.extra','',NULL,'2026-09-09 23:34:06'),('third-party.apple.appid','',NULL,'2026-09-15 20:17:59'),('third-party.apple.enabled','false',NULL,'2026-09-15 19:46:24'),('third-party.apple.extra','',NULL,'2026-09-15 19:46:24'),('third-party.apple.redirect-uri','',NULL,'2026-09-15 20:17:59'),('third-party.apple.secret','',NULL,'2026-09-15 20:17:59'),('third-party.card-order','[]',NULL,'2026-10-15 23:13:48'),('third-party.dingtalk.appid','',NULL,'2026-09-09 21:47:24'),('third-party.dingtalk.enabled','false',NULL,'2026-09-09 21:47:24'),('third-party.dingtalk.redirect-uri','',NULL,'2026-09-09 21:47:24'),('third-party.dingtalk.secret','',NULL,'2026-09-09 21:47:24'),('third-party.gitee.appid','',NULL,'2026-10-15 23:13:48'),('third-party.gitee.enabled','false',NULL,'2026-10-15 22:40:57'),('third-party.gitee.extra','',NULL,'2026-10-15 23:13:48'),('third-party.gitee.redirect-uri','',NULL,'2026-10-15 23:13:48'),('third-party.gitee.secret','',NULL,'2026-10-15 23:13:48'),('third-party.github.appid','',NULL,'2026-10-15 23:13:47'),('third-party.github.enabled','false',NULL,'2026-10-15 22:40:56'),('third-party.github.extra','',NULL,'2026-10-15 23:13:47'),('third-party.github.redirect-uri','',NULL,'2026-10-15 23:13:47'),('third-party.github.secret','',NULL,'2026-10-15 23:13:47'),('third-party.qq.appid','',NULL,'2026-09-09 22:24:23'),('third-party.qq.enabled','false',NULL,'2026-09-09 22:24:23'),('third-party.qq.extra','',NULL,'2026-09-15 19:46:30'),('third-party.qq.redirect-uri','',NULL,'2026-09-09 22:24:23'),('third-party.qq.secret','',NULL,'2026-09-09 22:24:23'),('third-party.wechat-enterprise-qrcode-v2.appid','',NULL,'2026-09-15 20:21:06'),('third-party.wechat-enterprise-qrcode-v2.enabled','false',NULL,'2026-09-15 20:19:31'),('third-party.wechat-enterprise-qrcode-v2.extra','',NULL,'2026-09-15 20:21:06'),('third-party.wechat-enterprise-qrcode-v2.redirect-uri','',NULL,'2026-09-15 20:21:06'),('third-party.wechat-enterprise-qrcode-v2.secret','',NULL,'2026-09-15 20:21:06'),('third-party.wechat-enterprise-qrcode.appid','',NULL,'2026-09-09 23:41:09'),('third-party.wechat-enterprise-qrcode.enabled','false',NULL,'2026-09-09 23:41:09'),('third-party.wechat-enterprise-qrcode.extra','',NULL,'2026-09-09 23:41:09'),('third-party.wechat-enterprise-qrcode.redirect-uri','',NULL,'2026-09-09 23:41:09'),('third-party.wechat-enterprise-qrcode.secret','',NULL,'2026-09-09 23:41:09'),('third-party.wechat-enterprise.appid','',NULL,'2026-09-15 19:46:27'),('third-party.wechat-enterprise.enabled','false',NULL,'2026-09-15 19:46:27'),('third-party.wechat-enterprise.extra','',NULL,'2026-09-15 19:46:27'),('third-party.wechat-enterprise.redirect-uri','',NULL,'2026-09-15 19:46:27'),('third-party.wechat-enterprise.secret','',NULL,'2026-09-15 19:46:27'),('third-party.wechat.appid','',NULL,'2026-09-09 21:59:41'),('third-party.wechat.enabled','false',NULL,'2026-09-09 21:59:41'),('third-party.wechat.redirect-uri','',NULL,'2026-09-09 21:59:41'),('third-party.wechat.secret','',NULL,'2026-09-09 21:59:41'),('third-party.weibo.appid','',NULL,'2026-09-15 20:18:08'),('third-party.weibo.enabled','false',NULL,'2026-09-15 19:46:22'),('third-party.weibo.extra','',NULL,'2026-09-15 19:46:22'),('third-party.weibo.redirect-uri','',NULL,'2026-09-15 20:18:08'),('third-party.weibo.secret','',NULL,'2026-09-15 20:18:08');
/*!40000 ALTER TABLE `sys_security_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_password_policy` WRITE;
/*!40000 ALTER TABLE `sys_password_policy` DISABLE KEYS */;
INSERT INTO `sys_password_policy` VALUES (1,8,1,1,1,1,1,0,'2026-09-09 15:38:19');
/*!40000 ALTER TABLE `sys_password_policy` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_auth_flow_step` WRITE;
/*!40000 ALTER TABLE `sys_auth_flow_step` DISABLE KEYS */;
INSERT INTO `sys_auth_flow_step` VALUES (10,'LOGIN','CAPTCHA',1,NULL,1),(11,'LOGIN','PASSWORD',2,NULL,1),(12,'LOGIN','MFA',3,'mfaEnabled',1);
/*!40000 ALTER TABLE `sys_auth_flow_step` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_register_config` WRITE;
/*!40000 ALTER TABLE `sys_register_config` DISABLE KEYS */;
INSERT INTO `sys_register_config` VALUES (1,1,50,0,60,1000,5000,500,'2026-07-26 20:15:11','2026-10-13 20:59:04');
/*!40000 ALTER TABLE `sys_register_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_register_email_config` WRITE;
/*!40000 ALTER TABLE `sys_register_email_config` DISABLE KEYS */;
INSERT INTO `sys_register_email_config` VALUES (1,0,NULL,NULL,NULL,NULL,NULL,'2026-07-26 20:15:11','2026-10-23 00:53:04');
/*!40000 ALTER TABLE `sys_register_email_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_register_mobile_config` WRITE;
/*!40000 ALTER TABLE `sys_register_mobile_config` DISABLE KEYS */;
INSERT INTO `sys_register_mobile_config` VALUES (1,0,'aliyun',NULL,NULL,NULL,NULL,'cn-hangzhou','dypnsapi.aliyuncs.com','2026-07-26 20:15:11','2026-09-07 01:50:25');
/*!40000 ALTER TABLE `sys_register_mobile_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_sign_in_config` WRITE;
/*!40000 ALTER TABLE `sys_sign_in_config` DISABLE KEYS */;
INSERT INTO `sys_sign_in_config` VALUES (1,1,5,5,0.00,'[{\"balance\":0,\"days\":3,\"exp\":10,\"points\":10},{\"balance\":0.5,\"days\":7,\"exp\":20,\"points\":20},{\"balance\":1,\"days\":14,\"exp\":30,\"points\":30}]',1,100,7,'2026-09-07 01:47:33','2026-08-24 19:57:37',5,1,3);
/*!40000 ALTER TABLE `sys_sign_in_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_sign_in_day_reward` WRITE;
/*!40000 ALTER TABLE `sys_sign_in_day_reward` DISABLE KEYS */;
INSERT INTO `sys_sign_in_day_reward` VALUES (45,1,5,7,0.00,1,'2026-09-07 22:48:08','2026-09-07 22:48:08');
/*!40000 ALTER TABLE `sys_sign_in_day_reward` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_referral_config` WRITE;
/*!40000 ALTER TABLE `sys_referral_config` DISABLE KEYS */;
INSERT INTO `sys_referral_config` VALUES (1,'GLOBAL',0,0.0500,0.0200,'',1,1,'2026-08-20 04:14:31','2026-09-29 20:46:17');
/*!40000 ALTER TABLE `sys_referral_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_friend_link_config` WRITE;
/*!40000 ALTER TABLE `sys_friend_link_config` DISABLE KEYS */;
INSERT INTO `sys_friend_link_config` VALUES (1,1,'请先在贵站添加本站链接，再提交友链申请。','2026-07-26 20:15:11','2026-10-06 01:48:27');
/*!40000 ALTER TABLE `sys_friend_link_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_friend_link_type` WRITE;
/*!40000 ALTER TABLE `sys_friend_link_type` DISABLE KEYS */;
INSERT INTO `sys_friend_link_type` VALUES (1,'合作伙伴','partner',2,160,60,'深度合作站点，图片形式展示',10,1,'2026-09-10 19:51:13','2026-09-10 19:51:13'),(2,'友情链接','friend',1,NULL,NULL,'互相交换的文字链接',20,1,'2026-09-10 20:35:38','2026-09-10 20:35:38'),(3,'推荐站点','recommend',2,120,40,'编辑器推荐的优质站点',30,1,'2026-09-10 19:51:13','2026-09-10 19:51:13');
/*!40000 ALTER TABLE `sys_friend_link_type` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_content_setting` WRITE;
/*!40000 ALTER TABLE `sys_content_setting` DISABLE KEYS */;
INSERT INTO `sys_content_setting` VALUES (1,'notice','top_limit','3','公告列表置顶展示条数上限','2026-09-10 19:51:13','2026-09-10 22:51:41'),(2,'notice','page_size','10','公告列表默认每页条数','2026-09-10 19:51:13','2026-09-10 22:51:41'),(3,'helpdoc','default_category','guide','帮助文档默认分类标识','2026-09-10 19:51:13','2026-09-10 19:51:13'),(4,'helpdoc','page_size','20','帮助文档列表默认每页条数','2026-09-10 19:51:13','2026-09-10 19:51:13'),(5,'homenews','default_category','news','首页动态默认分类标识','2026-09-10 19:51:13','2026-09-10 19:51:13'),(6,'homenews','show_limit','6','首页动态默认展示条数','2026-09-10 19:51:13','2026-09-10 19:51:13'),(7,'friendlink','default_type','partner','友链默认分组标识','2026-09-10 19:51:13','2026-09-10 19:51:13'),(8,'friendlink','show_limit','20','友链前台展示条数上限','2026-09-10 19:51:13','2026-09-10 19:51:13'),(9,'glossary','show_limit','50','术语词典前台展示条数上限','2026-09-10 19:51:13','2026-09-10 19:51:13');
/*!40000 ALTER TABLE `sys_content_setting` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_log_archive_config` WRITE;
/*!40000 ALTER TABLE `sys_log_archive_config` DISABLE KEYS */;
INSERT INTO `sys_log_archive_config` VALUES (1,'sys_interface_call_log',90,1,1,'2026-09-11 01:29:33','2026-10-06 02:36:57'),(2,'sys_login_log',90,1,1,'2026-09-11 01:29:33','2026-09-11 01:29:33'),(3,'sys_user_operation_log',90,1,1,'2026-09-11 01:29:33','2026-09-11 01:29:33'),(4,'sys_admin_operation_log',90,1,1,'2026-09-11 01:29:33','2026-09-11 01:29:33');
/*!40000 ALTER TABLE `sys_log_archive_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_user_call_log_cleanup_config` WRITE;
/*!40000 ALTER TABLE `sys_user_call_log_cleanup_config` DISABLE KEYS */;
INSERT INTO `sys_user_call_log_cleanup_config` VALUES (1,1,'01:00:00',30,'2026-10-27 12:34:39',0,'2026-10-27 12:34:39');
/*!40000 ALTER TABLE `sys_user_call_log_cleanup_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_home_notice_config` WRITE;
/*!40000 ALTER TABLE `sys_home_notice_config` DISABLE KEYS */;
INSERT INTO `sys_home_notice_config` VALUES (1,0,'','2026-07-26 20:15:11','2026-10-15 22:59:51');
/*!40000 ALTER TABLE `sys_home_notice_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_sql_api_runtime_config` WRITE;
/*!40000 ALTER TABLE `sys_sql_api_runtime_config` DISABLE KEYS */;
INSERT INTO `sys_sql_api_runtime_config` VALUES (1,500,5000,5000,30000,8192,100,10000,4,3000,30,200,200,5000,3600,1,'2026-08-26 01:00:41');
/*!40000 ALTER TABLE `sys_sql_api_runtime_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_message_template` WRITE;
/*!40000 ALTER TABLE `sys_message_template` DISABLE KEYS */;
INSERT INTO `sys_message_template` VALUES (1,'REGISTER_WELCOME','注册欢迎','SYSTEM','欢迎加入正贤Api平台','你好 {{nickname}}，注册成功！先领取新手引导，第一笔充值还有惊喜。','[{\"key\":\"nickname\",\"desc\":\"用户昵称\"},{\"key\":\"username\",\"desc\":\"用户名\"}]',1,'2026-09-15 16:37:49','2026-09-14 17:18:37'),(2,'RECHARGE_SUCCESS','充值到账','SYSTEM','充值到账','您的充值已到账：+{{amount}} 元（订单 {{orderNo}}），当前余额 {{balance}} 元。','[{\"key\":\"amount\",\"desc\":\"本次到账金额\"},{\"key\":\"balance\",\"desc\":\"当前余额\"},{\"key\":\"orderNo\",\"desc\":\"订单号\"}]',1,'2026-09-14 17:18:37','2026-09-14 17:18:37'),(3,'PACKAGE_OPENED','套餐开通成功','SYSTEM','套餐开通成功','您购买的「{{packageName}}」已开通（订单 {{orderNo}}），快去控制台使用吧。','[{\"key\":\"packageName\",\"desc\":\"套餐名称\"},{\"key\":\"orderNo\",\"desc\":\"订单号\"},{\"key\":\"orderType\",\"desc\":\"订单类型\"}]',1,'2026-09-14 17:18:37','2026-09-14 17:18:37'),(4,'REFERRAL_COMMISSION','佣金到账提醒','REFERRAL','佣金到账提醒','您推荐的用户产生了消费，佣金 +{{amount}} 元已入账，可在「推广中心」查看明细。','[{\"key\":\"amount\",\"desc\":\"佣金金额\"}]',1,'2026-09-14 17:18:37','2026-09-14 17:18:37'),(5,'REFERRAL_FIRST_RECHARGE','推荐用户首充提醒','REFERRAL','您推荐的用户完成首充','恭喜！您推荐的用户完成首次充值，预计佣金 {{amount}} 元将在结算后到账。','[{\"key\":\"nickname\",\"desc\":\"被推荐人昵称\"},{\"key\":\"amount\",\"desc\":\"预计佣金金额\"}]',1,'2026-09-14 17:18:37','2026-09-14 17:18:37'),(6,'WITHDRAW_SUCCESS','提现打款成功','REFERRAL','提现打款成功','您的提现申请（{{amount}} 元）已完成打款，请注意查收。','[{\"key\":\"amount\",\"desc\":\"打款金额\"}]',1,'2026-09-14 17:18:37','2026-09-14 17:18:37'),(11,'BAN_NOTICE','账号封禁通知','SECURITY','账号封禁通知','您的账号已被封禁（{{reason}}）{% if banUntil %}，至 {{banUntil}}{% endif %}。如有疑问请联系客服。','[{\"key\":\"reason\",\"desc\":\"封禁原因\"},{\"key\":\"banUntil\",\"desc\":\"解封时间（永久封禁为空）\"}]',1,'2026-09-14 18:17:19','2026-09-14 17:49:26'),(12,'UNBAN_NOTICE','账号解封通知','SECURITY','账号解封通知','您的账号已解除封禁，欢迎回来。',NULL,1,'2026-09-14 17:49:26','2026-09-14 17:49:26'),(17,'POINTS_GRANTED','积分发放通知','SYSTEM','积分发放通知','平台向您发放了 {{points}} 积分（{{title}}），可在积分商城使用。','[{\"key\":\"points\",\"desc\":\"发放积分数\"},{\"key\":\"title\",\"desc\":\"发放事由\"}]',1,'2026-09-14 18:17:21','2026-09-14 17:57:39'),(20,'FIRST_API_CALL','首次调用成功','SYSTEM','首次调用成功','您已成功完成首次 API 调用（{{interfaceName}}），控制台可查看调用明细。','[{\"key\":\"interfaceName\",\"desc\":\"接口名称\"}]',1,'2026-09-14 18:00:21','2026-09-14 18:00:21'),(64,'LEVEL_UP','等级提升','LEVEL_UP','等级提升','恭喜！您的成长值达到 {{totalExp}}，已自动升级至 {{levelName}}。','[{\"key\":\"levelName\",\"desc\":\"等级名称\"},{\"key\":\"totalExp\",\"desc\":\"当前成长值\"}]',1,'2026-09-15 16:37:49','2026-09-15 16:37:41'),(65,'SUBSCRIPTION_ACTIVATED','订阅开通成功','SYSTEM','订阅开通成功','租户「{{tenantName}}」的订阅「{{planName}}」已生效，有效期至 {{currentEnd}}（订单 {{orderNo}}）。','[{\"key\":\"tenantName\",\"desc\":\"租户名称\"},{\"key\":\"planName\",\"desc\":\"计划名称\"},{\"key\":\"currentEnd\",\"desc\":\"有效期至\"},{\"key\":\"orderNo\",\"desc\":\"订单号\"}]',1,'2026-09-15 22:17:32','2026-09-15 22:17:32'),(66,'SUBSCRIPTION_RENEWED','订阅续费成功','SYSTEM','订阅续费成功','租户「{{tenantName}}」的订阅「{{planName}}」已续费至 {{currentEnd}}。','[{\"key\":\"tenantName\",\"desc\":\"租户名称\"},{\"key\":\"planName\",\"desc\":\"计划名称\"},{\"key\":\"currentEnd\",\"desc\":\"续期至\"}]',1,'2026-09-15 22:17:32','2026-09-15 22:17:32'),(67,'SUBSCRIPTION_EXPIRING','订阅续费失败提醒','SYSTEM','订阅即将到期','租户「{{tenantName}}」的订阅「{{planName}}」自动续费失败（余额不足），已进入 7 天宽限期，请尽快充值，逾期订阅将失效。','[{\"key\":\"tenantName\",\"desc\":\"租户名称\"},{\"key\":\"planName\",\"desc\":\"计划名称\"}]',1,'2026-09-15 22:17:32','2026-09-15 22:17:32'),(78,'PROVIDER_APPLY_REJECTED','入驻申请驳回','SYSTEM','入驻申请未通过','很抱歉，您的服务商入驻申请未通过审核（原因：{{remark}}）。您可修改资料后重新提交。','[{\"key\":\"remark\",\"desc\":\"审核备注\"}]',1,'2026-09-18 23:19:13','2026-09-18 23:19:13'),(79,'INTERFACE_AUDIT_REJECTED','接口审核驳回','SYSTEM','接口审核未通过','您的接口「{{interfaceName}}」未通过审核（原因：{{remark}}）。请修改后重新提交审核。','[{\"key\":\"interfaceName\",\"desc\":\"接口名称\"},{\"key\":\"remark\",\"desc\":\"审核备注\"}]',1,'2026-09-18 23:19:13','2026-09-18 23:19:13'),(80,'WITHDRAW_REJECTED','提现驳回通知','REFERRAL','提现申请未通过','您的提现申请（{{amount}} 元）未通过审核（原因：{{remark}}），资金已退回结算余额。','[{\"key\":\"amount\",\"desc\":\"提现金额\"},{\"key\":\"remark\",\"desc\":\"审核备注\"}]',1,'2026-10-06 22:11:23','2026-09-18 23:19:13'),(82,'SCHEDULE_TASK_FAILED','定时任务失败告警','SYSTEM','定时任务执行失败','定时任务「{{taskName}}」执行失败：{{message}}','[{\"key\":\"taskName\",\"desc\":\"任务名称\"},{\"key\":\"message\",\"desc\":\"失败原因\"}]',1,'2026-10-13 20:40:03','2026-10-13 20:40:03');
/*!40000 ALTER TABLE `sys_message_template` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_notify_type` WRITE;
/*!40000 ALTER TABLE `sys_notify_type` DISABLE KEYS */;
INSERT INTO `sys_notify_type` VALUES (1,'LEVEL_UP','等级提升','会员等级升降与成长值里程碑提醒',1,0,'2026-09-14 15:20:36','2026-09-18 19:04:23'),(2,'SYSTEM','系统公告','平台系统公告',1,0,'2026-09-14 15:20:36','2026-09-14 15:20:36'),(3,'SECURITY','安全提醒','登录/封禁/密码等安全事件（用户不可关闭）',1,0,'2026-09-14 15:20:36','2026-09-14 15:20:36'),(4,'REFERRAL','佣金动态','佣金到账、提现打款、被推荐人动态',1,1,'2026-09-14 15:20:36','2026-09-14 15:20:36'),(5,'CAMPAIGN','营销活动','营销活动与里程碑消息',1,1,'2026-09-14 15:20:36','2026-09-14 15:48:22'),(6,'BADGE','徽章成就','徽章获得通知',1,1,'2026-09-14 15:20:36','2026-09-14 15:20:36');
/*!40000 ALTER TABLE `sys_notify_type` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_notification_channel` WRITE;
/*!40000 ALTER TABLE `sys_notification_channel` DISABLE KEYS */;
INSERT INTO `sys_notification_channel` VALUES (1,'运维Webhook示例','WEBHOOK','{\"webhookUrl\":\"https://example.com/hook/demo\",\"secret\":\"\"}',0,'测试渠道, 默认停用','2026-09-11 02:24:52','2026-09-11 02:24:52');
/*!40000 ALTER TABLE `sys_notification_channel` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_member_level` WRITE;
/*!40000 ALTER TABLE `sys_member_level` DISABLE KEYS */;
INSERT INTO `sys_member_level` VALUES (1,1,'见习会员',0,'#9ca3af',NULL,0.00,0,0,'[\"基础调用权限\"]',1,'2026-08-24 19:57:37','2026-08-24 19:57:37',NULL),(2,2,'青铜会员',100,'#b45309',NULL,0.02,1,200,'[\"计费 98 折\",\"QPS +1\",\"套餐日限额 +200\"]',1,'2026-08-24 19:57:37','2026-10-04 00:46:24',NULL),(3,3,'白银会员',500,'#64748b',NULL,0.05,2,500,'[\"计费 95 折\",\"QPS +2\",\"套餐日限额 +500\"]',1,'2026-08-24 19:57:37','2026-08-24 19:57:37',NULL),(4,4,'黄金会员',2000,'#d97706',NULL,0.08,3,1000,'[\"计费 92 折\",\"QPS +3\",\"套餐日限额 +1000\"]',1,'2026-08-24 19:57:37','2026-08-24 19:57:37',NULL),(5,5,'铂金会员',8000,'#0ea5e9',NULL,0.12,5,2000,'[\"计费 88 折\",\"QPS +5\",\"套餐日限额 +2000\"]',1,'2026-08-24 19:57:37','2026-08-24 19:57:37',NULL),(6,6,'钻石会员',30000,'#8b5cf6',NULL,0.15,8,5000,'[\"计费 85 折\",\"QPS +8\",\"套餐日限额 +5000\"]',1,'2026-08-24 19:57:37','2026-08-24 19:57:37',NULL);
/*!40000 ALTER TABLE `sys_member_level` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_badge` WRITE;
/*!40000 ALTER TABLE `sys_badge` DISABLE KEYS */;
INSERT INTO `sys_badge` VALUES (1,'SIGN_IN_STREAK_3','初来乍到','连续签到 3 天','mdi:certificate-outline','signin','BRONZE',3,0,1,1,2,1,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(2,'SIGN_IN_STREAK_7','七日之约','连续签到 7 天','mdi:certificate-outline','signin','BRONZE',7,0,1,1,2,2,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(3,'SIGN_IN_STREAK_14','半程坚持','连续签到 14 天','mdi:certificate-outline','signin','SILVER',14,0,1,1,2,3,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(4,'SIGN_IN_STREAK_30','月度恒心','连续签到 30 天','mdi:certificate-outline','signin','SILVER',30,0,1,1,0,4,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(5,'SIGN_IN_STREAK_60','持之以恒','连续签到 60 天','mdi:certificate-outline','signin','GOLD',60,0,1,1,0,5,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(6,'SIGN_IN_STREAK_100','百日筑基','连续签到 100 天','mdi:certificate-outline','signin','GOLD',100,0,1,1,0,6,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(7,'TOTAL_SIGN_IN_7','签到新人','累计签到 7 天','mdi:certificate-outline','signin','BRONZE',7,0,1,1,83,7,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(8,'TOTAL_SIGN_IN_30','签到常客','累计签到 30 天','mdi:certificate-outline','signin','BRONZE',30,0,1,1,6,8,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(9,'TOTAL_SIGN_IN_100','签到达人','累计签到 100 天','mdi:certificate-outline','signin','SILVER',100,0,1,1,0,9,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(10,'LEVEL_2','进阶会员','等级达到 Lv.2','mdi:certificate-outline','level','BRONZE',2,0,1,1,81,10,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(11,'LEVEL_3','资深会员','等级达到 Lv.3','mdi:certificate-outline','level','SILVER',3,0,1,1,59,11,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(12,'LEVEL_4','精英会员','等级达到 Lv.4','mdi:certificate-outline','level','GOLD',4,0,1,1,45,12,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(13,'LEVEL_5','至高会员','等级达到 Lv.5','mdi:certificate-outline','level','GOLD',5,0,1,1,22,13,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(14,'INVITE_COUNT_1','首次邀新','成功邀请 1 位好友','mdi:certificate-outline','referral','BRONZE',1,0,1,1,2,14,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(15,'INVITE_COUNT_10','推广先锋','成功邀请 10 位好友','mdi:certificate-outline','referral','SILVER',10,0,1,1,0,15,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(16,'INVITE_COUNT_50','推广大师','成功邀请 50 位好友','mdi:certificate-outline','referral','GOLD',50,0,1,1,0,16,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(17,'CONSUME_AMOUNT_100','首次消费','累计消费满 100','mdi:certificate-outline','consume','BRONZE',100,0,1,1,0,17,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(18,'CONSUME_AMOUNT_1000','消费达人','累计消费满 1000','mdi:certificate-outline','consume','SILVER',1000,0,1,1,0,18,'2026-09-15 00:20:36','2026-10-11 23:22:28'),(19,'WEEKLY_STREAK_4','周周不落','连续 4 个达成周','mdi:certificate-outline','signin','SILVER',4,0,1,1,0,19,'2026-09-15 00:20:36','2026-10-11 23:22:28');
/*!40000 ALTER TABLE `sys_badge` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_chart_type` WRITE;
/*!40000 ALTER TABLE `sys_chart_type` DISABLE KEYS */;
INSERT INTO `sys_chart_type` VALUES (1,'line','折线图','mdi:chart-line',NULL,'LineChart',1,1,'2026-09-11 01:29:33','2026-10-11 23:22:28'),(2,'bar','柱状图','mdi:chart-bar',NULL,'BarChart',1,2,'2026-09-11 01:29:33','2026-10-11 23:22:28'),(3,'pie','饼图','mdi:chart-pie',NULL,'PieChart',1,3,'2026-09-11 01:29:33','2026-10-11 23:22:28'),(4,'radar','雷达图','mdi:radar',NULL,'RadarChart',1,4,'2026-09-11 01:29:33','2026-10-11 23:22:28'),(5,'gauge','仪表盘','mdi:speedometer',NULL,'GaugeChart',1,5,'2026-09-11 01:29:33','2026-10-11 23:22:28'),(6,'map','地图','mdi:map-outline',NULL,'MapChart',1,6,'2026-09-11 01:29:33','2026-10-11 23:22:28'),(7,'table','数据表格','mdi:table',NULL,'DataTable',1,7,'2026-09-11 01:29:33','2026-10-11 23:22:28'),(8,'number','数字卡片','mdi:numeric',NULL,'NumberCard',1,8,'2026-09-11 01:29:33','2026-10-11 23:22:28'),(9,'scatter','散点图','mdi:view-grid-outline',NULL,'ScatterChart',1,9,'2026-09-11 01:29:33','2026-10-11 23:22:28');
/*!40000 ALTER TABLE `sys_chart_type` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_monitor` WRITE;
/*!40000 ALTER TABLE `sys_monitor` DISABLE KEYS */;
INSERT INTO `sys_monitor` VALUES (1,'正贤Api网关健康检查','HTTP','http://localhost:8080/api/chart-type/public/list',60,10,1,200,NULL,NULL,NULL,'A','探测后端网关公开接口可用性',1,'2026-09-11 02:24:52','2026-09-11 02:24:52'),(2,'本机Redis','TCP','127.0.0.1:6379',60,5,1,200,NULL,6379,NULL,'A','Redis连接探测',2,'2026-09-11 02:24:52','2026-09-11 02:24:52'),(3,'本机MySQL','TCP','127.0.0.1:3306',60,5,1,200,NULL,3306,NULL,'A','MySQL连接探测',3,'2026-09-11 02:24:52','2026-09-11 02:24:52');
/*!40000 ALTER TABLE `sys_monitor` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_alert_rule` WRITE;
/*!40000 ALTER TABLE `sys_alert_rule` DISABLE KEYS */;
INSERT INTO `sys_alert_rule` VALUES (1,'接口错误率告警','INTERFACE_ERROR_RATE',NULL,10.00,'>',300,60,'WARNING','OK','KEEP_LAST',1,'接口错误率超过10%持续5分钟','2026-09-11 01:29:33','2026-09-11 01:29:33',NULL,0),(2,'平台QPS异常告警','PLATFORM_QPS',NULL,1000.00,'>',60,30,'CRITICAL','OK','KEEP_LAST',1,'平台总QPS超过1000','2026-09-11 01:29:33','2026-09-11 01:29:33',NULL,0),(3,'单接口QPS告警','SINGLE_API_QPS',NULL,100.00,'>',60,30,'WARNING','OK','KEEP_LAST',1,'单接口QPS超过100','2026-09-11 01:29:33','2026-09-11 01:29:33',NULL,0),(4,'P95延迟告警','P95_LATENCY',NULL,2000.00,'>',300,60,'WARNING','OK','KEEP_LAST',1,'P95延迟超过2秒持续5分钟','2026-09-11 01:29:33','2026-09-11 01:29:33',NULL,0);
/*!40000 ALTER TABLE `sys_alert_rule` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_schedule_task` WRITE;
/*!40000 ALTER TABLE `sys_schedule_task` DISABLE KEYS */;
INSERT INTO `sys_schedule_task` VALUES (3,'内容块索引重建','CONTENT','contentBlockTask.rebuildAll','0 0 4 * * ?',3,0,1,'2026-10-25 04:00:00','SUCCESS',17,'执行结果：1','每日重建块级内容检索索引','2026-09-10 19:52:30','2026-10-25 04:00:00',0,2),(4,'孤儿索引清理','CONTENT','contentBlockTask.cleanOrphans','0 30 4 * * ?',3,0,1,'2026-10-25 04:30:00','SUCCESS',6,'执行结果：0','清理块级索引中已删除内容的孤儿记录','2026-09-10 19:52:30','2026-10-25 04:30:00',0,2),(8,'悬空引用清理','CONTENT','contentBlockTask.cleanDanglingRefs','0 0 5 * * ?',3,0,1,'2026-10-24 05:00:00','SUCCESS',10,'执行结果：0','每日清理块级悬空引用','2026-09-10 21:53:21','2026-10-24 05:00:00',0,2),(9,'SEO 内容补推送','CONTENT','contentPublishTask.pushPendingSeo','0 0 3 * * ?',3,0,1,'2026-10-25 03:00:00','SUCCESS',39,'执行结果：0','每日补推未推送的已发布内容','2026-09-10 21:53:21','2026-10-25 03:00:00',0,2),(10,'内容采集规则执行','CONTENT','contentCollectTask.runEnabledRules','0 0/30 * * * ?',3,0,1,'2026-10-27 17:30:00','SUCCESS',8,'执行结果：0','每30分钟执行处于运行态的采集规则','2026-09-10 21:53:21','2026-10-27 17:30:00',0,2),(13,'断签保护卡抵扣','MEMBER','memberGrowthTask.freezeProtect','0 10 0 * * ?',3,0,1,'2026-10-24 00:10:00','SUCCESS',26,'执行结果：0','昨日未签用户自动消耗保护卡保持连签','2026-09-15 00:38:28','2026-10-24 00:10:00',0,2),(14,'周目标连签计算','MEMBER','memberGrowthTask.weeklyStreak','0 20 0 ? * MON',3,0,1,'2026-10-19 00:20:00','SUCCESS',17,'执行结果：100','周一凌晨计算上周达成周与连告周数并发放奖励','2026-09-15 00:38:28','2026-10-19 00:20:00',0,2),(15,'排行榜日聚合重算','MEMBER','memberGrowthTask.leaderboardRecalc','0 30 0 * * ?',3,0,1,'2026-10-23 00:30:00','SUCCESS',13,'执行结果：3','签到/成长值/邀请三榜幂等重算','2026-09-15 00:38:28','2026-10-23 00:30:00',0,2),(16,'成长周报邮件','MEMBER','memberGrowthTask.growthDigest','0 0 9 ? * MON',3,0,1,'2026-10-12 09:01:08','SUCCESS',68029,'执行结果：25','每用户游标式周报邮件（发送成功才推进）','2026-09-15 00:38:28','2026-10-12 09:01:08',0,2),(17,'断签召回','MEMBER','memberGrowthTask.streakRecall','0 30 9 * * ?',3,0,1,'2026-10-24 09:30:00','SUCCESS',8,'执行结果：0','3天未签且历史连签≥7天用户召回','2026-09-15 00:38:28','2026-10-24 09:30:00',0,2),(18,'订阅Outbox分发','SUBSCRIPTION','subscriptionOutboxTask.dispatch','0 0/1 * * * ?',3,0,1,'2026-10-24 01:36:00','RUNNING',21,NULL,'订阅事件 Outbox 分发：僵尸复位+乐观抢占+退避重试（§6）','2026-09-15 22:38:19','2026-10-24 01:36:00',0,2),(19,'订阅Outbox清理','SUBSCRIPTION','subscriptionOutboxTask.cleanup','0 0 3 * * ?',3,0,1,'2026-10-25 03:00:00','SUCCESS',4,'执行结果：0','清理 30 天前 DONE 事件（§6 清理节点）','2026-09-15 22:38:19','2026-10-25 03:00:00',0,2),(20,'订阅续费扫描','SUBSCRIPTION','subscriptionBillingTask.renewScan','0 15 0 * * ?',3,0,1,'2026-10-19 00:15:00','SUCCESS',15,'执行结果：null','到期续费（仅余额直付，不做第三方支付代扣）/试用到期/PAST_DUE 宽限期满（§8）','2026-09-15 22:38:19','2026-10-19 00:15:00',0,2),(21,'订阅取消扫描','SUBSCRIPTION','subscriptionBillingTask.cancelScan','0 30 0 * * ?',3,0,1,'2026-10-23 00:30:00','SUCCESS',2,'执行结果：null','期末取消→CANCELLED→EXPIRED（§4.1 矩阵）','2026-09-15 22:38:19','2026-10-23 00:30:00',0,2),(22,'METERED账单生成','SUBSCRIPTION','subscriptionBillTask.generateMetered','0 40 0 1 * ?',3,0,1,'2026-10-01 00:40:00','SUCCESS',6,'执行结果：null','每月1日按租户聚合 callLog 出账（§5.2 METERED）','2026-09-15 22:38:19','2026-10-01 00:40:00',0,2),(23,'通用渠道订单兜底确认','PAYMENT','paymentOrderConfirmTask.confirmPendingGenericOrders','0 0/2 * * * ?',3,0,1,'2026-10-24 01:36:00','RUNNING',3,NULL,'扫未过期 PENDING 通用渠道订单，网关查单推进结算（防钱货两空）','2026-09-16 03:12:08','2026-10-24 01:36:00',0,2),(24,'套餐到期梯度提醒','PAYMENT','packageExpireReminderTask.scanExpireReminders','0 0 9 * * ?',3,0,1,'2026-10-24 09:00:00','SUCCESS',7,'执行结果：null','扫用户套餐 expire_time，-7/-3/-1/+1/+3 天梯度发站内信（B3）','2026-09-16 23:45:53','2026-10-24 09:00:00',0,2),(25,'用户订阅续费扫描','PAYMENT','userSubscriptionRenewTask.scanRenewals','0 20 0 * * ?',3,0,0,'2026-09-20 00:20:29','SUCCESS',5,'执行结果：null','用户级订阅自动续费（余额直付）+ 试用转正（B17）','2026-09-16 23:45:53','2026-09-21 00:58:06',0,2),(34,'回调渠道补单兜底','PAYMENT','paymentOrderConfirmTask.confirmPendingCallbackOrders','0 0/2 * * * ?',3,0,1,'2026-10-24 01:36:00','RUNNING',1,NULL,'扫超10分钟仍PENDING的支付宝/微信单，主动查单驱动终态（防回调丢失资金事故）','2026-10-13 19:08:04','2026-10-24 01:36:00',0,2),(35,'支付宝对账单下载比对','PAYMENT','alipayBillReconcileTask.reconcileYesterday','0 0 10 * * ?',3,0,0,'2026-10-23 10:03:00','DEAD',3,'连续失败超上限已挂起: 支付宝 AppID 未配置','拉前一天支付宝账单与平台订单逐笔比对，差异落RECONCILE通知日志（资金安全最后防线）','2026-10-13 19:45:09','2026-10-23 10:03:00',0,2),(36,'日终余额一致性校验','WALLET','walletConsistencyTask.execute','0 30 2 * * ?',3,0,1,'2026-10-25 02:30:00','SUCCESS',26,'执行结果：null','末条流水快照叠加其后卡密兑换加钱与退款净扣后应等于当前余额，漂移落error日志告警（只读校验）','2026-10-13 20:00:09','2026-10-25 02:30:00',0,2);
/*!40000 ALTER TABLE `sys_schedule_task` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_package_global` WRITE;
/*!40000 ALTER TABLE `sys_package_global` DISABLE KEYS */;
INSERT INTO `sys_package_global` VALUES (101,'标准会员',29.0000,30,1000,5,0,1,'适合个人开发者日常调用,全站接口通用.','2026-09-05 15:06:07','2026-09-05 15:45:32'),(102,'专业会员',99.0000,90,10000,20,1,1,'适合中小团队项目接入,兼顾配额与成本.','2026-09-05 15:06:07','2026-09-05 15:45:32'),(103,'旗舰会员',199.0000,365,0,0,0,1,'不限量调用，适合高并发核心业务。','2026-09-05 15:06:07','2026-09-05 15:06:07'),(110,'JDK21测试套餐',0.0000,30,0,0,0,1,'JDK21 迁移实测','2026-10-23 08:07:17','2026-10-23 08:07:17');
/*!40000 ALTER TABLE `sys_package_global` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_package_point` WRITE;
/*!40000 ALTER TABLE `sys_package_point` DISABLE KEYS */;
INSERT INTO `sys_package_point` VALUES (201,'体验装',10.0000,100,0,1,'100 点入门，按量计费试水首选。','2026-09-05 15:06:07','2026-09-05 15:06:07'),(202,'标准装',45.0000,500,0,1,'500 点，日常开发调试够用。','2026-09-05 15:06:07','2026-09-05 15:06:07'),(203,'进阶装',160.0000,2000,0,1,'2000 点，小型项目接入首选。','2026-09-05 15:06:07','2026-09-05 15:06:07'),(204,'超值装',699.0000,10000,1,1,'10000 点，批量采购更划算。','2026-09-05 15:06:07','2026-09-05 15:35:31');
/*!40000 ALTER TABLE `sys_package_point` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_payment_recharge_amount` WRITE;
/*!40000 ALTER TABLE `sys_payment_recharge_amount` DISABLE KEYS */;
INSERT INTO `sys_payment_recharge_amount` VALUES (1,10.0000,0.0000,1,10,'默认充值金额','2026-07-26 20:15:11','2026-10-07 22:31:34'),(2,30.0000,0.0000,1,20,'默认充值金额','2026-07-26 20:15:11','2026-07-26 20:15:11'),(3,50.0000,0.0000,1,30,'默认充值金额','2026-07-26 20:15:11','2026-07-26 20:15:11'),(4,100.0000,0.0000,1,40,'默认充值金额','2026-07-26 20:15:11','2026-07-26 20:15:11');
/*!40000 ALTER TABLE `sys_payment_recharge_amount` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_ticket_type` WRITE;
/*!40000 ALTER TABLE `sys_ticket_type` DISABLE KEYS */;
INSERT INTO `sys_ticket_type` VALUES (1,'AFTER_SALE','售后','PRODUCT','mdi:headset','#1890ff','接口使用问题、售后支持',NULL,24,72,NULL,1,1,10,'2026-08-24 21:37:31','2026-08-24 21:37:31'),(2,'COMPLAINT','投诉','OTHER','mdi:alert-circle-outline','#f5222d','对服务商或平台服务的投诉',NULL,12,48,NULL,1,1,20,'2026-08-24 21:37:31','2026-09-29 20:44:59'),(3,'SUGGESTION','建议','SUGGESTION','mdi:lightbulb-on-outline','#52c41a','功能建议与产品反馈',NULL,48,168,NULL,1,1,30,'2026-08-24 21:37:31','2026-09-29 20:44:58'),(4,'BUG','Bug 反馈','PRODUCT','mdi:bug-outline','#fa8c16','接口异常、数据错误等缺陷',NULL,12,48,NULL,1,1,40,'2026-08-24 21:37:31','2026-08-24 21:37:31');
/*!40000 ALTER TABLE `sys_ticket_type` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_ticket_inbox` WRITE;
/*!40000 ALTER TABLE `sys_ticket_inbox` DISABLE KEYS */;
INSERT INTO `sys_ticket_inbox` VALUES (1,'网页工单','WEB','用户在平台网页端提交的工单',1,'2026-09-10 00:05:30','2026-09-10 00:05:30'),(2,'邮件工单','EMAIL','通过邮件渠道进来的工单',1,'2026-09-10 00:05:30','2026-09-10 15:22:40');
/*!40000 ALTER TABLE `sys_ticket_inbox` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_provider_category` WRITE;
/*!40000 ALTER TABLE `sys_provider_category` DISABLE KEYS */;
INSERT INTO `sys_provider_category` VALUES (1,'程序员','programmer',NULL,1,0,'2026-08-15 22:45:37','2026-08-17 20:15:39',0),(2,'设计师','designer',NULL,2,0,'2026-08-15 22:45:37','2026-08-17 20:15:49',0),(3,'开发者工具','devtool','/api/icons/devtool.png',3,1,'2026-08-15 22:45:37','2026-08-15 22:45:37',0),(5,'111','1111',NULL,0,1,'2026-08-17 19:02:49','2026-08-19 22:01:38',0),(6,'111','111',NULL,0,0,'2026-08-17 19:13:24','2026-09-30 17:33:26',0),(13,'E2E删除语义','e2e_sem_test',NULL,0,1,'2026-08-17 21:54:15','2026-08-17 22:02:25',1),(14,'E2E禁用语义','e2e_disable_test',NULL,0,1,'2026-08-17 22:03:14','2026-08-17 22:04:53',1);
/*!40000 ALTER TABLE `sys_provider_category` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_point_exchange_rule` WRITE;
/*!40000 ALTER TABLE `sys_point_exchange_rule` DISABLE KEYS */;
INSERT INTO `sys_point_exchange_rule` VALUES (6,'INTERFACE_PACKAGE',301,1,50,1,10,'一言语录月卡：50积分','2026-09-08 19:05:39','2026-09-08 19:05:39'),(7,'INTERFACE_PACKAGE',301,2,125,1,20,'一言语录季卡：125积分','2026-09-08 19:05:39','2026-09-08 19:05:39'),(8,'INTERFACE_PACKAGE',302,3,95,1,30,'B站排行榜基础版：95积分','2026-09-08 19:05:39','2026-09-08 19:05:39'),(9,'INTERFACE_PACKAGE',302,4,245,1,40,'B站排行榜专业版：245积分','2026-09-08 19:05:39','2026-09-08 19:05:39'),(10,'GLOBAL_PACKAGE',101,NULL,145,1,10,'标准会员：145积分','2026-09-08 19:05:39','2026-09-08 19:05:39'),(11,'GLOBAL_PACKAGE',102,NULL,495,1,20,'专业会员：495积分','2026-09-08 19:05:39','2026-09-08 19:05:39'),(12,'GLOBAL_PACKAGE',103,NULL,995,1,30,'旗舰会员：995积分','2026-09-08 19:05:39','2026-09-08 19:05:39'),(13,'POINT_PACKAGE',201,NULL,50,1,60,'体验装 100 点','2026-09-08 20:11:20','2026-09-08 20:11:20'),(14,'POINT_PACKAGE',202,NULL,225,1,61,'标准装 500 点','2026-09-08 20:11:20','2026-09-08 20:11:20'),(15,'POINT_PACKAGE',203,NULL,800,1,62,'进阶装 2000 点','2026-09-08 20:11:20','2026-09-08 20:11:20'),(16,'POINT_PACKAGE',204,NULL,3500,1,63,'超值装 10000 点','2026-09-08 20:11:20','2026-09-08 20:11:20'),(18,'POINT_PACKAGE',201,NULL,60,0,70,NULL,'2026-09-08 20:30:08','2026-09-08 20:30:08'),(19,'POINT_PACKAGE',201,NULL,60,0,70,NULL,'2026-09-08 21:03:50','2026-09-08 21:03:50'),(20,'POINT_PACKAGE',201,NULL,60,0,70,NULL,'2026-09-08 21:04:45','2026-09-08 21:04:45');
/*!40000 ALTER TABLE `sys_point_exchange_rule` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_custom_page` WRITE;
/*!40000 ALTER TABLE `sys_custom_page` DISABLE KEYS */;
INSERT INTO `sys_custom_page` VALUES (20,'links-official','/links',1,'{\"schemas\":[{\"id\":\"links_root\",\"label\":\"页面\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"background\":\"#ffffff\",\"minHeight\":\"100vh\"}},\"children\":[{\"id\":\"links_hero\",\"label\":\"友链页头\",\"type\":\"flex\",\"props\":{\"gap\":8,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"align\":\"center\",\"style\":{\"padding\":\"48px 16px 8px\",\"textAlign\":\"center\"}},\"children\":[{\"id\":\"links_hero_title\",\"label\":\"页头标题\",\"type\":\"title\",\"props\":{\"content\":\"友情链接\",\"level\":1,\"style\":{\"margin\":\"0\",\"fontSize\":\"22px\",\"fontWeight\":600,\"color\":\"#09090b\"}}},{\"id\":\"links_hero_desc\",\"label\":\"页头描述\",\"type\":\"paragraph\",\"props\":{\"content\":\"优质 API 站点、开发者资源与合作伙伴展示，欢迎互换友链。\",\"style\":{\"margin\":\"8px 0 0\",\"fontSize\":\"14px\",\"color\":\"#71717b\"}}}]},{\"id\":\"links_content\",\"label\":\"友链内容\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"width\":\"min(1280px, calc(100% - 32px))\",\"margin\":\"0 auto\",\"paddingTop\":\"20px\"}},\"children\":[{\"id\":\"nf_card\",\"label\":\"友链列表\",\"type\":\"nf-friend-links-card\",\"props\":{}}]},{\"id\":\"links_apply_area\",\"label\":\"申请友链区\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"width\":\"min(1280px, calc(100% - 32px))\",\"margin\":\"0 auto\",\"paddingTop\":\"20px\",\"paddingBottom\":\"56px\"}},\"children\":[{\"id\":\"nf_apply\",\"label\":\"友链申请条\",\"props\":{\"buttonText\":\"申请友链\",\"showButton\":true,\"showText\":true,\"text\":\"想和我们交换友情链接？\"},\"type\":\"nf-friend-apply\"}]}]}]}','友情链接(官方)','友情链接页官方可视化版本：页头与说明文案、友链站点卡片（推荐站点 / 合作伙伴 / 友情链接三组，含站点图标与外链跳转）、底部「想和我们交换友情链接？」申请条，内置申请弹窗（网站名称、网站地址、网站 Logo、网站描述、已放置我方链接的页面）','{\"schemas\":[{\"id\":\"links_root\",\"label\":\"页面\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"background\":\"#ffffff\",\"minHeight\":\"100vh\"}},\"children\":[{\"id\":\"links_hero\",\"label\":\"友链页头\",\"type\":\"flex\",\"props\":{\"gap\":8,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"align\":\"center\",\"style\":{\"padding\":\"48px 16px 8px\",\"textAlign\":\"center\"}},\"children\":[{\"id\":\"links_hero_title\",\"label\":\"页头标题\",\"type\":\"title\",\"props\":{\"content\":\"友情链接\",\"level\":1,\"style\":{\"margin\":\"0\",\"fontSize\":\"22px\",\"fontWeight\":600,\"color\":\"#09090b\"}}},{\"id\":\"links_hero_desc\",\"label\":\"页头描述\",\"type\":\"paragraph\",\"props\":{\"content\":\"优质 API 站点、开发者资源与合作伙伴展示，欢迎互换友链。\",\"style\":{\"margin\":\"8px 0 0\",\"fontSize\":\"14px\",\"color\":\"#71717b\"}}}]},{\"id\":\"links_content\",\"label\":\"友链内容\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"width\":\"min(1280px, calc(100% - 32px))\",\"margin\":\"0 auto\",\"paddingTop\":\"20px\"}},\"children\":[{\"id\":\"nf_card\",\"label\":\"友链列表\",\"type\":\"nf-friend-links-card\",\"props\":{}}]},{\"id\":\"links_apply_area\",\"label\":\"申请友链区\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"width\":\"min(1280px, calc(100% - 32px))\",\"margin\":\"0 auto\",\"paddingTop\":\"20px\",\"paddingBottom\":\"56px\"}},\"children\":[{\"id\":\"nf_apply\",\"label\":\"友链申请条\",\"props\":{\"buttonText\":\"申请友链\",\"showButton\":true,\"showText\":true,\"text\":\"想和我们交换友情链接？\"},\"type\":\"nf-friend-apply\"}]}]}]}',1,0,1,1,'2026-08-30 17:03:26','2026-10-12 17:41:17',0,NULL),(21,'home-official','/',1,'{\"schemas\":[{\"id\":\"home_root\",\"label\":\"首页\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":false,\"style\":{\"background\":\"#f5f6fa\",\"paddingBottom\":\"1px\"}},\"children\":[{\"id\":\"home_hero\",\"label\":\"首页搜索区\",\"type\":\"nf-hero-search\",\"props\":{\"becomeProviderText\":\"成为服务商\",\"heroDesc\":\"汇聚优质接口资源，赋能开发者以卓越的 API 解决方案\",\"heroTitle\":\"企业智能化 - 创新服务枢纽\",\"hotLabel\":\"热门关键词：\",\"marketPath\":\"/apilist\",\"placeholderApi\":\"请输入接口名称\",\"placeholderProvider\":\"请输入服务商名称\",\"primaryColor\":\"#165dff\",\"portalShow\":true,\"bannerImage\":\"/home-nsmao/banner.jpg\",\"servicePortalCards\":[{\"action\":\"发布接口\",\"desc\":\"服务大众，稳定接口\",\"icon\":\"/home-nsmao/portal-icon-4.png\",\"title\":\"接口提交\"},{\"action\":\"人才大厅\",\"desc\":\"多服务商，在线服务\",\"icon\":\"/home-nsmao/portal-icon-5.png\",\"title\":\"物色人才\"},{\"action\":\"接口管理\",\"desc\":\"管理系统，数据多元\",\"icon\":\"/home-nsmao/portal-icon-6.png\",\"title\":\"API管理\"}],\"userPortalCards\":[{\"action\":\"前往市场\",\"desc\":\"海量接口，毫秒响应\",\"icon\":\"/home-nsmao/portal-icon-10.png\",\"title\":\"API市场\",\"to\":\"/apilist\"},{\"action\":\"查看文档\",\"desc\":\"质量文档，一点即通\",\"icon\":\"/home-nsmao/portal-icon-8.webp\",\"title\":\"帮助文档\",\"to\":\"/#help-center\"},{\"action\":\"查看通知\",\"desc\":\"接口广播，信息响应\",\"icon\":\"/home-nsmao/portal-icon-9.png\",\"title\":\"通知中心\",\"to\":\"/notice\"}]},\"children\":[]},{\"id\":\"home_feed_row\",\"label\":\"动态条\",\"type\":\"flex\",\"props\":{\"align\":\"stretch\",\"gap\":0,\"justify\":\"flex-start\",\"vertical\":false,\"wrap\":false,\"style\":{\"background\":\"#fff\",\"borderRadius\":\"8px\",\"boxShadow\":\"0 2px 12px #0000000a\",\"margin\":\"8px auto 24px\",\"width\":\"min(1280px, calc(100% - 32px))\"}},\"children\":[{\"id\":\"home_feed_purchase\",\"label\":\"最新购买动态\",\"type\":\"nf-feed-ticker\",\"props\":{\"dotColor\":\"#f33\",\"feedTitle\":\"最新购买动态\",\"feedType\":\"purchase\",\"interval\":3.2,\"style\":{\"flex\":\"1 1 0\",\"minWidth\":\"0\"}},\"children\":[]},{\"id\":\"home_feed_provider\",\"label\":\"最新服务商\",\"type\":\"nf-feed-ticker\",\"props\":{\"dotColor\":\"#fa0\",\"feedTitle\":\"最新服务商\",\"feedType\":\"provider\",\"interval\":3.2,\"style\":{\"flex\":\"1 1 0\",\"minWidth\":\"0\"}},\"children\":[]},{\"id\":\"home_feed_notice\",\"label\":\"平台公告\",\"type\":\"nf-feed-ticker\",\"props\":{\"dotColor\":\"#60a5fa\",\"feedTitle\":\"平台公告\",\"feedType\":\"notice\",\"interval\":3.2,\"style\":{\"borderLeft\":\"1px solid #f2f2f2\",\"flex\":\"1 1 0\",\"minWidth\":\"0\"}},\"children\":[]}]},{\"id\":\"home_cate\",\"label\":\"分类产品\",\"type\":\"nf-home-cate\",\"props\":{\"primaryColor\":\"#165dff\",\"priceColor\":\"#fe5200\",\"headIcon\":\"/home-nsmao/portal-icon-12.png\",\"marketPath\":\"/apilist\",\"groups\":[{\"title\":\"天气动态\",\"desc\":\"天气API接口\",\"bg\":\"/home-nsmao/cate-weather.jpg\",\"cards\":[{\"name\":\"天气查询\",\"desc\":\"根据提交的区域查询地区降雨等情况\",\"icon\":\"mingcute:cloud-line\",\"pointPrice\":0,\"price\":0.1},{\"name\":\"每日一言\",\"desc\":\"随机每日一言\",\"icon\":\"mingcute:message-1-line\",\"pointPrice\":0,\"price\":0.0001},{\"name\":\"随机壁纸生成\",\"desc\":\"随机生成4K壁纸\",\"icon\":\"mingcute:pic-line\",\"pointPrice\":0,\"price\":0.01},{\"name\":\"IP地区查询\",\"desc\":\"查询IP地址归属地及运营商信息\",\"icon\":\"mingcute:map-pin-line\",\"pointPrice\":0,\"price\":0.001}]},{\"title\":\"娱乐工具\",\"desc\":\"提供娱乐消遣API\",\"bg\":\"/home-nsmao/cate-entertainment.jpg\",\"cards\":[{\"name\":\"各大热榜\",\"desc\":\"获取各大平台热门榜单数据聚合\",\"icon\":\"mingcute:trending-up-line\",\"pointPrice\":0,\"price\":0.0005},{\"name\":\"OCR识图\",\"desc\":\"精准识别图片中的文字内容，中英文皆可解析\",\"icon\":\"mingcute:scan-2-line\",\"pointPrice\":0,\"price\":0.005},{\"name\":\"AI图片鉴黄\",\"desc\":\"通过AI技术识别图片内容\",\"icon\":\"mingcute:sparkles-2-line\",\"pointPrice\":0,\"price\":0.01},{\"name\":\"OCR解析文档\",\"desc\":\"OCR解析 pdf 以及 doc 文档内容\",\"icon\":\"mingcute:file-line\",\"pointPrice\":0,\"price\":0.005}]},{\"title\":\"生活服务\",\"desc\":\"生活服务、物流新闻等接口\",\"bg\":\"/home-nsmao/cate-life.jpg\",\"cards\":[{\"name\":\"域名Whois查询\",\"desc\":\"查询域名注册信息\",\"icon\":\"mingcute:global-line\",\"pointPrice\":0,\"price\":0.001},{\"name\":\"图片转Base64\",\"desc\":\"图片转Base64编码\",\"icon\":\"mingcute:transform-line\",\"pointPrice\":0,\"price\":0.0001},{\"name\":\"天气查询\",\"desc\":\"根据提交的区域查询地区降雨等情况\",\"icon\":\"mingcute:cloud-line\",\"pointPrice\":0,\"price\":0.1},{\"name\":\"每日一言\",\"desc\":\"随机每日一言\",\"icon\":\"mingcute:message-1-line\",\"pointPrice\":0,\"price\":0.0001}]},{\"title\":\"人工智能\",\"desc\":\"AI智能对话、绘画\",\"bg\":\"/home-nsmao/cate-ai.jpg\",\"cards\":[{\"name\":\"随机壁纸生成\",\"desc\":\"随机生成4K壁纸\",\"icon\":\"mingcute:pic-line\",\"pointPrice\":0,\"price\":0.01},{\"name\":\"IP地区查询\",\"desc\":\"查询IP地址归属地及运营商信息\",\"icon\":\"mingcute:map-pin-line\",\"pointPrice\":0,\"price\":0.001},{\"name\":\"各大热榜\",\"desc\":\"获取各大平台热门榜单数据聚合\",\"icon\":\"mingcute:trending-up-line\",\"pointPrice\":0,\"price\":0.0005},{\"name\":\"OCR识图\",\"desc\":\"精准识别图片中的文字内容，中英文皆可解析\",\"icon\":\"mingcute:scan-2-line\",\"pointPrice\":0,\"price\":0.005}]},{\"title\":\"前沿技术\",\"desc\":\"人脸识别、二维码解析\",\"bg\":\"/home-nsmao/cate-tech.jpg\",\"cards\":[{\"name\":\"AI图片鉴黄\",\"desc\":\"通过AI技术识别图片内容\",\"icon\":\"mingcute:sparkles-2-line\",\"pointPrice\":0,\"price\":0.01},{\"name\":\"OCR解析文档\",\"desc\":\"OCR解析 pdf 以及 doc 文档内容\",\"icon\":\"mingcute:file-line\",\"pointPrice\":0,\"price\":0.005},{\"name\":\"域名Whois查询\",\"desc\":\"查询域名注册信息\",\"icon\":\"mingcute:global-line\",\"pointPrice\":0,\"price\":0.001},{\"name\":\"图片转Base64\",\"desc\":\"图片转Base64编码\",\"icon\":\"mingcute:transform-line\",\"pointPrice\":0,\"price\":0.0001}]}],\"dataSource\":\"auto\"}},{\"id\":\"home_service\",\"label\":\"优质服务商推荐\",\"type\":\"nf-home-service\",\"props\":{\"primaryColor\":\"#165dff\",\"priceColor\":\"#fe5200\",\"siteName\":\"正贤Api\",\"vipBanner\":\"/home-nsmao/vip-banner.png\",\"providerLogo\":\"/home-nsmao/provider-logo.png\",\"sectionSub\":\"企业服务商\",\"sectionTitle\":\"优质服务商推荐\",\"providers\":[{\"name\":\"数据工坊\",\"avatar\":\"/home-nsmao/provider-logo.png\",\"isOfficial\":true,\"count\":\"128\",\"biz\":\"数据接口\",\"link\":\"/apilist\"},{\"name\":\"智算云\",\"avatar\":\"/home-nsmao/provider-logo.png\",\"isOfficial\":false,\"count\":\"96\",\"biz\":\"AI服务\",\"link\":\"/apilist\"},{\"name\":\"极客API\",\"avatar\":\"/home-nsmao/provider-logo.png\",\"isOfficial\":true,\"count\":\"73\",\"biz\":\"工具服务\",\"link\":\"/apilist\"},{\"name\":\"万象数据\",\"avatar\":\"/home-nsmao/provider-logo.png\",\"isOfficial\":false,\"count\":\"52\",\"biz\":\"内容服务\",\"link\":\"/apilist\"}],\"dataSource\":\"auto\"},\"children\":[]},{\"id\":\"home_join\",\"label\":\"入驻流程区\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":0,\"wrap\":false,\"style\":{\"background\":\"#fff\",\"borderRadius\":\"12px\",\"padding\":\"36px 0\",\"marginBottom\":\"24px\"}},\"children\":[{\"id\":\"home_join_inner\",\"label\":\"区块内容容器\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":0,\"wrap\":false,\"style\":{\"width\":\"min(1280px, calc(100% - 32px))\",\"margin\":\"0 auto\"}},\"children\":[{\"id\":\"home_join_head\",\"label\":\"区块标题\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"center\",\"align\":\"center\",\"gap\":6,\"wrap\":false,\"style\":{\"marginBottom\":\"22px\"}},\"children\":[{\"id\":\"home_join_sub\",\"label\":\"小标题\",\"type\":\"text\",\"props\":{\"content\":\"开店流程\",\"style\":{\"fontSize\":\"13px\",\"fontWeight\":600,\"color\":\"#165dff\",\"letterSpacing\":\"0.08em\"}}},{\"id\":\"home_join_title\",\"label\":\"大标题\",\"type\":\"title\",\"props\":{\"content\":\"申请成为服务商\",\"level\":2,\"style\":{\"fontSize\":\"28px\",\"fontWeight\":800,\"color\":\"#1d2129\",\"margin\":0}}}]},{\"id\":\"home_join_steps\",\"label\":\"流程步骤行\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":8,\"wrap\":false,\"style\":{\"marginBottom\":\"8px\"}},\"children\":[{\"id\":\"home_join_step_1\",\"label\":\"步骤1\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":0,\"wrap\":false,\"style\":{\"position\":\"relative\",\"flex\":\"1 1 0\",\"minWidth\":0,\"padding\":\"0 24px\",\"textAlign\":\"center\",\"fontSize\":\"12px\",\"lineHeight\":\"16px\"}},\"children\":[{\"id\":\"home_join_step_img_1\",\"label\":\"步骤1配图\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/business-join-1.svg\",\"style\":{\"display\":\"block\",\"width\":\"102px\",\"height\":\"102px\",\"margin\":\"0 auto 14px\",\"borderRadius\":\"50%\"}}},{\"id\":\"home_join_step_h_1\",\"label\":\"步骤1标题\",\"type\":\"title\",\"props\":{\"content\":\"第一步.提交申请\",\"level\":3,\"style\":{\"margin\":0,\"fontSize\":\"15px\",\"fontWeight\":700,\"color\":\"#2b2b2b\"}}},{\"id\":\"home_join_step_time_1\",\"label\":\"步骤1耗时\",\"type\":\"text\",\"props\":{\"content\":\"约5分钟\",\"style\":{\"marginTop\":\"14px\",\"padding\":\"2px 8px\",\"fontSize\":\"12px\",\"color\":\"#85878c\",\"background\":\"#f9f9fa\",\"borderRadius\":\"10px\"}}},{\"id\":\"home_join_step_desc_1\",\"label\":\"步骤1描述\",\"type\":\"paragraph\",\"props\":{\"content\":\"填写基本信息提交入驻申请\",\"style\":{\"margin\":\"12px 0 0\",\"fontSize\":\"12px\",\"color\":\"#85878c\",\"textAlign\":\"center\"}}},{\"id\":\"home_join_arrow_1\",\"label\":\"步骤1箭头\",\"type\":\"text\",\"props\":{\"content\":\"›\",\"style\":{\"position\":\"absolute\",\"top\":\"50px\",\"right\":\"-14px\",\"fontSize\":\"26px\",\"lineHeight\":1,\"color\":\"rgba(22, 93, 255, 0.35)\"}}}]},{\"id\":\"home_join_step_2\",\"label\":\"步骤2\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":0,\"wrap\":false,\"style\":{\"position\":\"relative\",\"flex\":\"1 1 0\",\"minWidth\":0,\"padding\":\"0 24px\",\"textAlign\":\"center\",\"fontSize\":\"12px\",\"lineHeight\":\"16px\"}},\"children\":[{\"id\":\"home_join_step_img_2\",\"label\":\"步骤2配图\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/business-join-2.svg\",\"style\":{\"display\":\"block\",\"width\":\"102px\",\"height\":\"102px\",\"margin\":\"0 auto 14px\",\"borderRadius\":\"50%\"}}},{\"id\":\"home_join_step_h_2\",\"label\":\"步骤2标题\",\"type\":\"title\",\"props\":{\"content\":\"第二步.账户验证\",\"level\":3,\"style\":{\"margin\":0,\"fontSize\":\"15px\",\"fontWeight\":700,\"color\":\"#2b2b2b\"}}},{\"id\":\"home_join_step_time_2\",\"label\":\"步骤2耗时\",\"type\":\"text\",\"props\":{\"content\":\"约10分钟\",\"style\":{\"marginTop\":\"14px\",\"padding\":\"2px 8px\",\"fontSize\":\"12px\",\"color\":\"#85878c\",\"background\":\"#f9f9fa\",\"borderRadius\":\"10px\"}}},{\"id\":\"home_join_step_desc_2\",\"label\":\"步骤2描述\",\"type\":\"paragraph\",\"props\":{\"content\":\"联网非留存身份验证\",\"style\":{\"margin\":\"12px 0 0\",\"fontSize\":\"12px\",\"color\":\"#85878c\",\"textAlign\":\"center\"}}},{\"id\":\"home_join_arrow_2\",\"label\":\"步骤2箭头\",\"type\":\"text\",\"props\":{\"content\":\"›\",\"style\":{\"position\":\"absolute\",\"top\":\"50px\",\"right\":\"-14px\",\"fontSize\":\"26px\",\"lineHeight\":1,\"color\":\"rgba(22, 93, 255, 0.35)\"}}}]},{\"id\":\"home_join_step_3\",\"label\":\"步骤3\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":0,\"wrap\":false,\"style\":{\"position\":\"relative\",\"flex\":\"1 1 0\",\"minWidth\":0,\"padding\":\"0 24px\",\"textAlign\":\"center\",\"fontSize\":\"12px\",\"lineHeight\":\"16px\"}},\"children\":[{\"id\":\"home_join_step_img_3\",\"label\":\"步骤3配图\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/business-join-3.svg\",\"style\":{\"display\":\"block\",\"width\":\"102px\",\"height\":\"102px\",\"margin\":\"0 auto 14px\",\"borderRadius\":\"50%\"}}},{\"id\":\"home_join_step_h_3\",\"label\":\"步骤3标题\",\"type\":\"title\",\"props\":{\"content\":\"第三步.平台审核\",\"level\":3,\"style\":{\"margin\":0,\"fontSize\":\"15px\",\"fontWeight\":700,\"color\":\"#2b2b2b\"}}},{\"id\":\"home_join_step_time_3\",\"label\":\"步骤3耗时\",\"type\":\"text\",\"props\":{\"content\":\"约1-5个工作日\",\"style\":{\"marginTop\":\"14px\",\"padding\":\"2px 8px\",\"fontSize\":\"12px\",\"color\":\"#85878c\",\"background\":\"#f9f9fa\",\"borderRadius\":\"10px\"}}},{\"id\":\"home_join_step_desc_3\",\"label\":\"步骤3描述\",\"type\":\"paragraph\",\"props\":{\"content\":\"平台进行资质审核\",\"style\":{\"margin\":\"12px 0 0\",\"fontSize\":\"12px\",\"color\":\"#85878c\",\"textAlign\":\"center\"}}},{\"id\":\"home_join_arrow_3\",\"label\":\"步骤3箭头\",\"type\":\"text\",\"props\":{\"content\":\"›\",\"style\":{\"position\":\"absolute\",\"top\":\"50px\",\"right\":\"-14px\",\"fontSize\":\"26px\",\"lineHeight\":1,\"color\":\"rgba(22, 93, 255, 0.35)\"}}}]},{\"id\":\"home_join_step_4\",\"label\":\"步骤4\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":0,\"wrap\":false,\"style\":{\"position\":\"relative\",\"flex\":\"1 1 0\",\"minWidth\":0,\"padding\":\"0 24px\",\"textAlign\":\"center\",\"fontSize\":\"12px\",\"lineHeight\":\"16px\"}},\"children\":[{\"id\":\"home_join_step_img_4\",\"label\":\"步骤4配图\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/business-join-4.svg\",\"style\":{\"display\":\"block\",\"width\":\"102px\",\"height\":\"102px\",\"margin\":\"0 auto 14px\",\"borderRadius\":\"50%\"}}},{\"id\":\"home_join_step_h_4\",\"label\":\"步骤4标题\",\"type\":\"title\",\"props\":{\"content\":\"第四步.店铺开通\",\"level\":3,\"style\":{\"margin\":0,\"fontSize\":\"15px\",\"fontWeight\":700,\"color\":\"#2b2b2b\"}}},{\"id\":\"home_join_step_time_4\",\"label\":\"步骤4耗时\",\"type\":\"text\",\"props\":{\"content\":\"约1-7个工作日\",\"style\":{\"marginTop\":\"14px\",\"padding\":\"2px 8px\",\"fontSize\":\"12px\",\"color\":\"#85878c\",\"background\":\"#f9f9fa\",\"borderRadius\":\"10px\"}}},{\"id\":\"home_join_step_desc_4\",\"label\":\"步骤4描述\",\"type\":\"paragraph\",\"props\":{\"content\":\"通过协议，可上传发布API管理付费\",\"style\":{\"margin\":\"12px 0 0\",\"fontSize\":\"12px\",\"color\":\"#85878c\",\"textAlign\":\"center\"}}}]}]},{\"id\":\"home_join_action\",\"label\":\"入驻按钮区\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"center\",\"align\":\"center\",\"gap\":0,\"wrap\":false,\"style\":{\"width\":\"100%\"}},\"children\":[{\"id\":\"home_join_btn\",\"label\":\"申请入驻 →\",\"type\":\"button\",\"props\":{\"type\":\"primary\",\"href\":\"/auth/register\",\"style\":{\"height\":\"44px\",\"padding\":\"0 28px\",\"fontSize\":\"15px\",\"fontWeight\":600,\"borderRadius\":\"6px\",\"background\":\"#165dff\"}}}]}]}]},{\"id\":\"home_code\",\"label\":\"API管理流程区\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":0,\"wrap\":false,\"style\":{\"marginBottom\":\"48px\"}},\"children\":[{\"id\":\"home_code_inner\",\"label\":\"区块内容容器\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":0,\"wrap\":false,\"style\":{\"width\":\"min(1280px, calc(100% - 32px))\",\"margin\":\"0 auto\"}},\"children\":[{\"id\":\"home_code_head\",\"label\":\"区块标题\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"center\",\"align\":\"center\",\"gap\":6,\"wrap\":false,\"style\":{\"marginBottom\":\"22px\"}},\"children\":[{\"id\":\"home_code_sub\",\"label\":\"小标题\",\"type\":\"text\",\"props\":{\"content\":\"多语言支持\",\"style\":{\"fontSize\":\"13px\",\"fontWeight\":600,\"color\":\"#165dff\",\"letterSpacing\":\"0.08em\"}}},{\"id\":\"home_code_title\",\"label\":\"大标题\",\"type\":\"title\",\"props\":{\"content\":\"API管理流程\",\"level\":2,\"style\":{\"fontSize\":\"28px\",\"fontWeight\":800,\"color\":\"#1d2129\",\"margin\":0}}}]},{\"id\":\"home_code_grid\",\"label\":\"左右分栏\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":18,\"wrap\":false},\"children\":[{\"id\":\"home_code_left\",\"label\":\"左栏\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":0,\"wrap\":false},\"children\":[{\"id\":\"home_code_langs\",\"label\":\"语言卡片网格\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":14,\"wrap\":true},\"children\":[{\"id\":\"home_code_lang_golang\",\"label\":\"Goland卡片\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":12,\"wrap\":false,\"style\":{\"height\":\"106px\",\"padding\":\"22px\",\"boxSizing\":\"border-box\",\"background\":\"linear-gradient(#ffffffbf, #ffffff7a)\",\"borderRadius\":\"16px\",\"boxShadow\":\"3px 4px 20px #c3c3d23d\",\"flex\":\"1 1 calc(50% - 7px)\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_golang_icon\",\"label\":\"Goland图标\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/lang-golang.svg\",\"style\":{\"width\":\"44px\",\"height\":\"44px\",\"flex\":\"0 0 auto\"}}},{\"id\":\"home_code_lang_golang_txt\",\"label\":\"Goland文字\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":4,\"wrap\":false,\"style\":{\"marginLeft\":\"12px\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_golang_h\",\"label\":\"Goland名称\",\"type\":\"title\",\"props\":{\"content\":\"Goland\",\"level\":5,\"style\":{\"margin\":0,\"fontSize\":\"18px\",\"fontWeight\":700,\"color\":\"#121212\"}}},{\"id\":\"home_code_lang_golang_p\",\"label\":\"Goland扩展名\",\"type\":\"text\",\"props\":{\"content\":\".go\",\"style\":{\"margin\":0,\"fontSize\":\"13px\",\"color\":\"#85878c\"}}}]}]},{\"id\":\"home_code_lang_php\",\"label\":\"PHP卡片\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":12,\"wrap\":false,\"style\":{\"height\":\"106px\",\"padding\":\"22px\",\"boxSizing\":\"border-box\",\"background\":\"linear-gradient(#ffffffbf, #ffffff7a)\",\"borderRadius\":\"16px\",\"boxShadow\":\"3px 4px 20px #c3c3d23d\",\"flex\":\"1 1 calc(50% - 7px)\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_php_icon\",\"label\":\"PHP图标\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/lang-php.svg\",\"style\":{\"width\":\"44px\",\"height\":\"44px\",\"flex\":\"0 0 auto\"}}},{\"id\":\"home_code_lang_php_txt\",\"label\":\"PHP文字\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":4,\"wrap\":false,\"style\":{\"marginLeft\":\"12px\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_php_h\",\"label\":\"PHP名称\",\"type\":\"title\",\"props\":{\"content\":\"PHP\",\"level\":5,\"style\":{\"margin\":0,\"fontSize\":\"18px\",\"fontWeight\":700,\"color\":\"#121212\"}}},{\"id\":\"home_code_lang_php_p\",\"label\":\"PHP扩展名\",\"type\":\"text\",\"props\":{\"content\":\".php\",\"style\":{\"margin\":0,\"fontSize\":\"13px\",\"color\":\"#85878c\"}}}]}]},{\"id\":\"home_code_lang_java\",\"label\":\"Java卡片\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":12,\"wrap\":false,\"style\":{\"height\":\"106px\",\"padding\":\"22px\",\"boxSizing\":\"border-box\",\"background\":\"linear-gradient(#ffffffbf, #ffffff7a)\",\"borderRadius\":\"16px\",\"boxShadow\":\"3px 4px 20px #c3c3d23d\",\"flex\":\"1 1 calc(50% - 7px)\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_java_icon\",\"label\":\"Java图标\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/lang-java.svg\",\"style\":{\"width\":\"44px\",\"height\":\"44px\",\"flex\":\"0 0 auto\"}}},{\"id\":\"home_code_lang_java_txt\",\"label\":\"Java文字\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":4,\"wrap\":false,\"style\":{\"marginLeft\":\"12px\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_java_h\",\"label\":\"Java名称\",\"type\":\"title\",\"props\":{\"content\":\"Java\",\"level\":5,\"style\":{\"margin\":0,\"fontSize\":\"18px\",\"fontWeight\":700,\"color\":\"#121212\"}}},{\"id\":\"home_code_lang_java_p\",\"label\":\"Java扩展名\",\"type\":\"text\",\"props\":{\"content\":\".java\",\"style\":{\"margin\":0,\"fontSize\":\"13px\",\"color\":\"#85878c\"}}}]}]},{\"id\":\"home_code_lang_python\",\"label\":\"Python卡片\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":12,\"wrap\":false,\"style\":{\"height\":\"106px\",\"padding\":\"22px\",\"boxSizing\":\"border-box\",\"background\":\"linear-gradient(#ffffffbf, #ffffff7a)\",\"borderRadius\":\"16px\",\"boxShadow\":\"3px 4px 20px #c3c3d23d\",\"flex\":\"1 1 calc(50% - 7px)\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_python_icon\",\"label\":\"Python图标\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/lang-python.svg\",\"style\":{\"width\":\"44px\",\"height\":\"44px\",\"flex\":\"0 0 auto\"}}},{\"id\":\"home_code_lang_python_txt\",\"label\":\"Python文字\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":4,\"wrap\":false,\"style\":{\"marginLeft\":\"12px\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_python_h\",\"label\":\"Python名称\",\"type\":\"title\",\"props\":{\"content\":\"Python\",\"level\":5,\"style\":{\"margin\":0,\"fontSize\":\"18px\",\"fontWeight\":700,\"color\":\"#121212\"}}},{\"id\":\"home_code_lang_python_p\",\"label\":\"Python扩展名\",\"type\":\"text\",\"props\":{\"content\":\".py\",\"style\":{\"margin\":0,\"fontSize\":\"13px\",\"color\":\"#85878c\"}}}]}]},{\"id\":\"home_code_lang_nodejs\",\"label\":\"Node.js卡片\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":12,\"wrap\":false,\"style\":{\"height\":\"106px\",\"padding\":\"22px\",\"boxSizing\":\"border-box\",\"background\":\"linear-gradient(#ffffffbf, #ffffff7a)\",\"borderRadius\":\"16px\",\"boxShadow\":\"3px 4px 20px #c3c3d23d\",\"flex\":\"1 1 calc(50% - 7px)\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_nodejs_icon\",\"label\":\"Node.js图标\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/lang-nodejs.svg\",\"style\":{\"width\":\"44px\",\"height\":\"44px\",\"flex\":\"0 0 auto\"}}},{\"id\":\"home_code_lang_nodejs_txt\",\"label\":\"Node.js文字\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":4,\"wrap\":false,\"style\":{\"marginLeft\":\"12px\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_nodejs_h\",\"label\":\"Node.js名称\",\"type\":\"title\",\"props\":{\"content\":\"Node.js\",\"level\":5,\"style\":{\"margin\":0,\"fontSize\":\"18px\",\"fontWeight\":700,\"color\":\"#121212\"}}},{\"id\":\"home_code_lang_nodejs_p\",\"label\":\"Node.js扩展名\",\"type\":\"text\",\"props\":{\"content\":\".js\",\"style\":{\"margin\":0,\"fontSize\":\"13px\",\"color\":\"#85878c\"}}}]}]},{\"id\":\"home_code_lang_swift\",\"label\":\"Swift卡片\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":12,\"wrap\":false,\"style\":{\"height\":\"106px\",\"padding\":\"22px\",\"boxSizing\":\"border-box\",\"background\":\"linear-gradient(#ffffffbf, #ffffff7a)\",\"borderRadius\":\"16px\",\"boxShadow\":\"3px 4px 20px #c3c3d23d\",\"flex\":\"1 1 calc(50% - 7px)\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_swift_icon\",\"label\":\"Swift图标\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/lang-swift.svg\",\"style\":{\"width\":\"44px\",\"height\":\"44px\",\"flex\":\"0 0 auto\"}}},{\"id\":\"home_code_lang_swift_txt\",\"label\":\"Swift文字\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":4,\"wrap\":false,\"style\":{\"marginLeft\":\"12px\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_swift_h\",\"label\":\"Swift名称\",\"type\":\"title\",\"props\":{\"content\":\"Swift\",\"level\":5,\"style\":{\"margin\":0,\"fontSize\":\"18px\",\"fontWeight\":700,\"color\":\"#121212\"}}},{\"id\":\"home_code_lang_swift_p\",\"label\":\"Swift扩展名\",\"type\":\"text\",\"props\":{\"content\":\".swift\",\"style\":{\"margin\":0,\"fontSize\":\"13px\",\"color\":\"#85878c\"}}}]}]},{\"id\":\"home_code_lang_cs\",\"label\":\"C#卡片\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":12,\"wrap\":false,\"style\":{\"height\":\"106px\",\"padding\":\"22px\",\"boxSizing\":\"border-box\",\"background\":\"linear-gradient(#ffffffbf, #ffffff7a)\",\"borderRadius\":\"16px\",\"boxShadow\":\"3px 4px 20px #c3c3d23d\",\"flex\":\"1 1 calc(50% - 7px)\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_cs_icon\",\"label\":\"C#图标\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/lang-cs.svg\",\"style\":{\"width\":\"44px\",\"height\":\"44px\",\"flex\":\"0 0 auto\"}}},{\"id\":\"home_code_lang_cs_txt\",\"label\":\"C#文字\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":4,\"wrap\":false,\"style\":{\"marginLeft\":\"12px\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_cs_h\",\"label\":\"C#名称\",\"type\":\"title\",\"props\":{\"content\":\"C#\",\"level\":5,\"style\":{\"margin\":0,\"fontSize\":\"18px\",\"fontWeight\":700,\"color\":\"#121212\"}}},{\"id\":\"home_code_lang_cs_p\",\"label\":\"C#扩展名\",\"type\":\"text\",\"props\":{\"content\":\".cs\",\"style\":{\"margin\":0,\"fontSize\":\"13px\",\"color\":\"#85878c\"}}}]}]},{\"id\":\"home_code_lang_javascript\",\"label\":\"Javascript卡片\",\"type\":\"flex\",\"props\":{\"vertical\":false,\"justify\":\"flex-start\",\"align\":\"center\",\"gap\":12,\"wrap\":false,\"style\":{\"height\":\"106px\",\"padding\":\"22px\",\"boxSizing\":\"border-box\",\"background\":\"linear-gradient(#ffffffbf, #ffffff7a)\",\"borderRadius\":\"16px\",\"boxShadow\":\"3px 4px 20px #c3c3d23d\",\"flex\":\"1 1 calc(50% - 7px)\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_javascript_icon\",\"label\":\"Javascript图标\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/lang-javascript.svg\",\"style\":{\"width\":\"44px\",\"height\":\"44px\",\"flex\":\"0 0 auto\"}}},{\"id\":\"home_code_lang_javascript_txt\",\"label\":\"Javascript文字\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":4,\"wrap\":false,\"style\":{\"marginLeft\":\"12px\",\"minWidth\":0}},\"children\":[{\"id\":\"home_code_lang_javascript_h\",\"label\":\"Javascript名称\",\"type\":\"title\",\"props\":{\"content\":\"Javascript\",\"level\":5,\"style\":{\"margin\":0,\"fontSize\":\"18px\",\"fontWeight\":700,\"color\":\"#121212\"}}},{\"id\":\"home_code_lang_javascript_p\",\"label\":\"Javascript扩展名\",\"type\":\"text\",\"props\":{\"content\":\".js\",\"style\":{\"margin\":0,\"fontSize\":\"13px\",\"color\":\"#85878c\"}}}]}]}]},{\"id\":\"home_code_note1\",\"label\":\"说明条\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":4,\"wrap\":false,\"style\":{\"margin\":\"14px 0 0\",\"padding\":\"12px 16px\",\"background\":\"rgba(22, 93, 255, 0.06)\",\"borderLeft\":\"3px solid #165dff\",\"borderRadius\":\"6px\"}},\"children\":[{\"id\":\"home_code_note1_h\",\"label\":\"说明标题\",\"type\":\"text\",\"props\":{\"content\":\"API 支持\",\"style\":{\"margin\":0,\"fontSize\":\"14px\",\"fontWeight\":700,\"color\":\"#2b2b2b\"}}},{\"id\":\"home_code_note1_p\",\"label\":\"说明内容\",\"type\":\"text\",\"props\":{\"content\":\"多种编程语言接入\",\"style\":{\"margin\":0,\"fontSize\":\"13px\",\"color\":\"#85878c\"}}}]}]},{\"id\":\"home_code_right\",\"label\":\"右栏\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":14,\"wrap\":false},\"children\":[{\"id\":\"home_code_box_1\",\"label\":\"图片框1\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":0,\"wrap\":false,\"style\":{\"padding\":\"10px\",\"background\":\"#fff\",\"borderRadius\":\"16px\",\"boxShadow\":\"0 2px 12px rgba(0, 0, 0, 0.04)\"}},\"children\":[{\"id\":\"home_code_img_1\",\"label\":\"流程图1\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/code-1.png\",\"style\":{\"display\":\"block\",\"width\":\"100%\",\"borderRadius\":\"12px\"}}},{\"id\":\"home_code_note_1\",\"label\":\"说明条\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":4,\"wrap\":false,\"style\":{\"margin\":\"14px 0 0\",\"padding\":\"12px 16px\",\"background\":\"rgba(22, 93, 255, 0.06)\",\"borderLeft\":\"3px solid #165dff\",\"borderRadius\":\"6px\"}},\"children\":[{\"id\":\"home_code_note_1_h\",\"label\":\"说明标题\",\"type\":\"text\",\"props\":{\"content\":\"API 对接\",\"style\":{\"margin\":0,\"fontSize\":\"14px\",\"fontWeight\":700,\"color\":\"#2b2b2b\"}}},{\"id\":\"home_code_note_1_p\",\"label\":\"说明内容\",\"type\":\"text\",\"props\":{\"content\":\"流程化数据验证接入\",\"style\":{\"margin\":0,\"fontSize\":\"13px\",\"color\":\"#85878c\"}}}]}]},{\"id\":\"home_code_box_2\",\"label\":\"图片框2\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":0,\"wrap\":false,\"style\":{\"padding\":\"10px\",\"background\":\"#fff\",\"borderRadius\":\"16px\",\"boxShadow\":\"0 2px 12px rgba(0, 0, 0, 0.04)\"}},\"children\":[{\"id\":\"home_code_img_2\",\"label\":\"流程图2\",\"type\":\"image\",\"props\":{\"src\":\"/api/epic-runtime/home-nsmao/code-2.png\",\"style\":{\"display\":\"block\",\"width\":\"100%\",\"borderRadius\":\"12px\"}}},{\"id\":\"home_code_note_2\",\"label\":\"说明条\",\"type\":\"flex\",\"props\":{\"vertical\":true,\"justify\":\"flex-start\",\"align\":\"stretch\",\"gap\":4,\"wrap\":false,\"style\":{\"margin\":\"14px 0 0\",\"padding\":\"12px 16px\",\"background\":\"rgba(22, 93, 255, 0.06)\",\"borderLeft\":\"3px solid #165dff\",\"borderRadius\":\"6px\"}},\"children\":[{\"id\":\"home_code_note_2_h\",\"label\":\"说明标题\",\"type\":\"text\",\"props\":{\"content\":\"API 售后\",\"style\":{\"margin\":0,\"fontSize\":\"14px\",\"fontWeight\":700,\"color\":\"#2b2b2b\"}}},{\"id\":\"home_code_note_2_p\",\"label\":\"说明内容\",\"type\":\"text\",\"props\":{\"content\":\"团队专业技术支持\",\"style\":{\"margin\":0,\"fontSize\":\"13px\",\"color\":\"#85878c\"}}}]}]}]}]}]}]},{\"id\":\"home_doc_head\",\"label\":\"文档区标题\",\"type\":\"flex\",\"props\":{\"align\":\"center\",\"gap\":6,\"justify\":\"center\",\"vertical\":true,\"wrap\":false,\"style\":{\"margin\":\"8px 0 22px\"}},\"children\":[{\"id\":\"home_doc_sub\",\"label\":\"小标题\",\"type\":\"text\",\"props\":{\"content\":\"快速上手\",\"style\":{\"color\":\"#165dff\",\"fontSize\":\"13px\",\"fontWeight\":600,\"letterSpacing\":\"0.08em\"}}},{\"id\":\"home_doc_title\",\"label\":\"大标题\",\"type\":\"title\",\"props\":{\"content\":\"API全新动态\",\"level\":2,\"style\":{\"fontSize\":\"28px\",\"fontWeight\":800,\"margin\":\"0\"}}}]},{\"id\":\"home_doc_row\",\"label\":\"文档卡三列\",\"type\":\"flex\",\"props\":{\"align\":\"stretch\",\"gap\":18,\"justify\":\"flex-start\",\"vertical\":false,\"wrap\":false,\"style\":{\"margin\":\"0 auto 56px\",\"width\":\"min(1280px, calc(100% - 32px))\"}},\"children\":[{\"id\":\"home_doc_card_1\",\"label\":\"常见问题卡\",\"type\":\"nf-doc-card\",\"props\":{\"bodyHeight\":\"290px\",\"headerCn\":\"常见问题 | 常见问题\",\"headerEn\":\"Normal Problem\",\"headerImage\":\"/home-nsmao/doc-header-1.png\",\"items\":[{\"answer\":\"接口统一返回 code/data/msg 结构，错误时携带错误码与错误消息，按错误码判断类型：400 检查请求参数，401 检查API密钥，403 确认账户权限，404 检查请求地址，500 稍后重试或联系支持。\",\"date\":\"06-09\",\"title\":\"如何处理API返回的错误信息？\"},{\"answer\":\"返回为 JSON 结构，包含 code 状态码、data 业务数据与 msg 提示信息。\",\"date\":\"06-08\",\"title\":\"API返回数据格式是什么？\"},{\"answer\":\"可升级会员套餐获得更高的每秒请求上限，或在控制台查看当前速率配置。\",\"date\":\"06-07\",\"title\":\"如何提高API请求的速率限制？\"},{\"answer\":\"检查请求头是否携带有效的 Nice-Apikey，并确认 Key 状态与接口权限。\",\"date\":\"06-05\",\"title\":\"API请求失败，返回401未授权错误，怎么办？\"},{\"answer\":\"注册登录后在控制台「Key管理」中创建全站 Key 或接口专属 Key。\",\"date\":\"06-03\",\"title\":\"如何获取API密钥？\"}],\"style\":{\"flex\":\"1 1 0\",\"minWidth\":\"0\"},\"dataSource\":\"auto\",\"categoryCode\":\"faq\"}},{\"id\":\"home_doc_card_2\",\"label\":\"公司新闻卡\",\"type\":\"nf-doc-card\",\"props\":{\"bodyHeight\":\"290px\",\"headerCn\":\"公司新闻 | 公司新闻\",\"headerEn\":\"Company Dynamics\",\"headerImage\":\"/home-nsmao/doc-header-2.png\",\"items\":[{\"answer\":\"为了更好地支持开发者，平台推出API开发者支持计划，提供详细的API文档与多商户服务，帮助企业提高营收与曝光量。\",\"date\":\"06-09\",\"title\":\"平台推出开发者支持计划\"},{\"answer\":\"多起接入案例已完成沉淀，覆盖数据查询、内容识别等典型场景。\",\"date\":\"06-06\",\"title\":\"API集成成功案例分享\"},{\"answer\":\"新版接口在数据处理链路上做了优化，平均响应耗时进一步降低。\",\"date\":\"06-02\",\"title\":\"发布新版API，提升数据处理速度\"},{\"answer\":\"与多家平台达成合作，接口生态持续扩大。\",\"date\":\"05-28\",\"title\":\"达成生态合作\"}],\"style\":{\"flex\":\"1 1 0\",\"minWidth\":\"0\"},\"dataSource\":\"auto\",\"categoryCode\":\"company\"}},{\"id\":\"home_doc_card_3\",\"label\":\"行业新闻卡\",\"type\":\"nf-doc-card\",\"props\":{\"bodyHeight\":\"290px\",\"headerCn\":\"行业新闻 | 行业新闻\",\"headerEn\":\"Industry News\",\"headerImage\":\"/home-nsmao/doc-header-3.png\",\"items\":[{\"answer\":\"越来越多平台按实际调用量结算，开发者只为真实用量付费，接入成本更透明可控。\",\"date\":\"06-09\",\"title\":\"接口按量计费成为主流\"},{\"answer\":\"密钥签名、IP 白名单与请求加密逐步成为接入标配，调用链路更安全。\",\"date\":\"06-04\",\"title\":\"接口鉴权与加密成接入标配\"},{\"answer\":\"企业更倾向通过统一入口聚合多家服务商接口，减少重复对接与维护成本。\",\"date\":\"05-30\",\"title\":\"多商户接口聚合需求上升\"},{\"answer\":\"可用率与响应耗时成为选型关键指标，稳定服务成为核心竞争力。\",\"date\":\"05-21\",\"title\":\"接口可用率成为选型硬指标\"}],\"style\":{\"flex\":\"1 1 0\",\"minWidth\":\"0\"},\"dataSource\":\"auto\",\"categoryCode\":\"industry\"}}]}]}],\"canvas\":{\"mode\":\"desktop\",\"width\":1280}}','首页(官方)','首页官方可视化版本：顶部搜索区、三组实时动态条（最新购买动态 / 最新服务商 / 平台公告）、分类产品、优质服务商推荐、申请成为服务商四步流程（提交申请、账户验证、平台审核、店铺开通）与入驻入口、API 管理流程（8 种编程语言接入卡片、API 对接与 API 售后说明）、API 全新动态三栏文档卡（常见问题 / 公司新闻 / 行业新闻）','{\"schemas\": [{\"id\": \"home_root\", \"label\": \"首页\", \"type\": \"flex\", \"props\": {\"gap\": 0, \"justify\": \"flex-start\", \"vertical\": true, \"wrap\": false, \"style\": {\"background\": \"#f5f6fa\", \"paddingBottom\": \"1px\"}}, \"children\": [{\"id\": \"home_hero\", \"label\": \"首页搜索区\", \"type\": \"nf-hero-search\", \"props\": {\"becomeProviderText\": \"成为服务商\", \"heroDesc\": \"汇聚优质接口资源，赋能开发者以卓越的 API 解决方案\", \"heroTitle\": \"企业智能化 - 创新服务枢纽\", \"hotLabel\": \"热门关键词：\", \"marketPath\": \"/apilist\", \"placeholderApi\": \"请输入接口名称\", \"placeholderProvider\": \"请输入服务商名称\", \"primaryColor\": \"#165dff\", \"portalShow\": true, \"bannerImage\": \"/home-nsmao/banner.jpg\", \"servicePortalCards\": [{\"action\": \"发布接口\", \"desc\": \"服务大众，稳定接口\", \"icon\": \"/home-nsmao/portal-icon-4.png\", \"title\": \"接口提交\"}, {\"action\": \"人才大厅\", \"desc\": \"多服务商，在线服务\", \"icon\": \"/home-nsmao/portal-icon-5.png\", \"title\": \"物色人才\"}, {\"action\": \"接口管理\", \"desc\": \"管理系统，数据多元\", \"icon\": \"/home-nsmao/portal-icon-6.png\", \"title\": \"API管理\"}], \"userPortalCards\": [{\"action\": \"前往市场\", \"desc\": \"海量接口，毫秒响应\", \"icon\": \"/home-nsmao/portal-icon-10.png\", \"title\": \"API市场\", \"to\": \"/apilist\"}, {\"action\": \"查看文档\", \"desc\": \"质量文档，一点即通\", \"icon\": \"/home-nsmao/portal-icon-8.webp\", \"title\": \"帮助文档\", \"to\": \"/#help-center\"}, {\"action\": \"查看通知\", \"desc\": \"接口广播，信息响应\", \"icon\": \"/home-nsmao/portal-icon-9.png\", \"title\": \"通知中心\", \"to\": \"/notice\"}]}, \"children\": []}, {\"id\": \"home_feed_row\", \"label\": \"动态条\", \"type\": \"flex\", \"props\": {\"align\": \"stretch\", \"gap\": 0, \"justify\": \"flex-start\", \"vertical\": false, \"wrap\": false, \"style\": {\"background\": \"#fff\", \"borderRadius\": \"8px\", \"boxShadow\": \"0 2px 12px #0000000a\", \"margin\": \"8px auto 24px\", \"width\": \"min(1280px, calc(100% - 32px))\"}}, \"children\": [{\"id\": \"home_feed_purchase\", \"label\": \"最新购买动态\", \"type\": \"nf-feed-ticker\", \"props\": {\"dotColor\": \"#f33\", \"feedTitle\": \"最新购买动态\", \"feedType\": \"purchase\", \"interval\": 3.2, \"style\": {\"flex\": \"1 1 0\", \"minWidth\": \"0\"}}, \"children\": []}, {\"id\": \"home_feed_provider\", \"label\": \"最新服务商\", \"type\": \"nf-feed-ticker\", \"props\": {\"dotColor\": \"#fa0\", \"feedTitle\": \"最新服务商\", \"feedType\": \"provider\", \"interval\": 3.2, \"style\": {\"flex\": \"1 1 0\", \"minWidth\": \"0\"}}, \"children\": []}, {\"id\": \"home_feed_notice\", \"label\": \"平台公告\", \"type\": \"nf-feed-ticker\", \"props\": {\"dotColor\": \"#60a5fa\", \"feedTitle\": \"平台公告\", \"feedType\": \"notice\", \"interval\": 3.2, \"style\": {\"flex\": \"1 1 0\", \"minWidth\": \"0\"}}, \"children\": []}]}, {\"id\": \"home_cate\", \"label\": \"分类产品\", \"type\": \"nf-home-cate\", \"props\": {\"primaryColor\": \"#165dff\", \"priceColor\": \"#fe5200\", \"headIcon\": \"/home-nsmao/portal-icon-12.png\", \"marketPath\": \"/apilist\", \"groups\": [{\"title\": \"天气动态\", \"desc\": \"天气API接口\", \"bg\": \"/home-nsmao/cate-weather.jpg\", \"cards\": [{\"name\": \"天气查询\", \"desc\": \"根据提交的区域查询地区降雨等情况\", \"icon\": \"mingcute:cloud-line\", \"pointPrice\": 0, \"price\": 0.1}, {\"name\": \"每日一言\", \"desc\": \"随机每日一言\", \"icon\": \"mingcute:message-1-line\", \"pointPrice\": 0, \"price\": 0.0001}, {\"name\": \"随机壁纸生成\", \"desc\": \"随机生成4K壁纸\", \"icon\": \"mingcute:pic-line\", \"pointPrice\": 0, \"price\": 0.01}, {\"name\": \"IP地区查询\", \"desc\": \"查询IP地址归属地及运营商信息\", \"icon\": \"mingcute:map-pin-line\", \"pointPrice\": 0, \"price\": 0.001}]}, {\"title\": \"娱乐工具\", \"desc\": \"提供娱乐消遣API\", \"bg\": \"/home-nsmao/cate-entertainment.jpg\", \"cards\": [{\"name\": \"各大热榜\", \"desc\": \"获取各大平台热门榜单数据聚合\", \"icon\": \"mingcute:trending-up-line\", \"pointPrice\": 0, \"price\": 0.0005}, {\"name\": \"OCR识图\", \"desc\": \"精准识别图片中的文字内容，中英文皆可解析\", \"icon\": \"mingcute:scan-2-line\", \"pointPrice\": 0, \"price\": 0.005}, {\"name\": \"AI图片鉴黄\", \"desc\": \"通过AI技术识别图片内容\", \"icon\": \"mingcute:sparkles-2-line\", \"pointPrice\": 0, \"price\": 0.01}, {\"name\": \"OCR解析文档\", \"desc\": \"OCR解析 pdf 以及 doc 文档内容\", \"icon\": \"mingcute:file-line\", \"pointPrice\": 0, \"price\": 0.005}]}, {\"title\": \"生活服务\", \"desc\": \"生活服务、物流新闻等接口\", \"bg\": \"/home-nsmao/cate-life.jpg\", \"cards\": [{\"name\": \"域名Whois查询\", \"desc\": \"查询域名注册信息\", \"icon\": \"mingcute:global-line\", \"pointPrice\": 0, \"price\": 0.001}, {\"name\": \"图片转Base64\", \"desc\": \"图片转Base64编码\", \"icon\": \"mingcute:transform-line\", \"pointPrice\": 0, \"price\": 0.0001}, {\"name\": \"天气查询\", \"desc\": \"根据提交的区域查询地区降雨等情况\", \"icon\": \"mingcute:cloud-line\", \"pointPrice\": 0, \"price\": 0.1}, {\"name\": \"每日一言\", \"desc\": \"随机每日一言\", \"icon\": \"mingcute:message-1-line\", \"pointPrice\": 0, \"price\": 0.0001}]}, {\"title\": \"人工智能\", \"desc\": \"AI智能对话、绘画\", \"bg\": \"/home-nsmao/cate-ai.jpg\", \"cards\": [{\"name\": \"随机壁纸生成\", \"desc\": \"随机生成4K壁纸\", \"icon\": \"mingcute:pic-line\", \"pointPrice\": 0, \"price\": 0.01}, {\"name\": \"IP地区查询\", \"desc\": \"查询IP地址归属地及运营商信息\", \"icon\": \"mingcute:map-pin-line\", \"pointPrice\": 0, \"price\": 0.001}, {\"name\": \"各大热榜\", \"desc\": \"获取各大平台热门榜单数据聚合\", \"icon\": \"mingcute:trending-up-line\", \"pointPrice\": 0, \"price\": 0.0005}, {\"name\": \"OCR识图\", \"desc\": \"精准识别图片中的文字内容，中英文皆可解析\", \"icon\": \"mingcute:scan-2-line\", \"pointPrice\": 0, \"price\": 0.005}]}, {\"title\": \"前沿技术\", \"desc\": \"人脸识别、二维码解析\", \"bg\": \"/home-nsmao/cate-tech.jpg\", \"cards\": [{\"name\": \"AI图片鉴黄\", \"desc\": \"通过AI技术识别图片内容\", \"icon\": \"mingcute:sparkles-2-line\", \"pointPrice\": 0, \"price\": 0.01}, {\"name\": \"OCR解析文档\", \"desc\": \"OCR解析 pdf 以及 doc 文档内容\", \"icon\": \"mingcute:file-line\", \"pointPrice\": 0, \"price\": 0.005}, {\"name\": \"域名Whois查询\", \"desc\": \"查询域名注册信息\", \"icon\": \"mingcute:global-line\", \"pointPrice\": 0, \"price\": 0.001}, {\"name\": \"图片转Base64\", \"desc\": \"图片转Base64编码\", \"icon\": \"mingcute:transform-line\", \"pointPrice\": 0, \"price\": 0.0001}]}], \"dataSource\": \"auto\"}}, {\"id\": \"home_service\", \"label\": \"优质服务商推荐\", \"type\": \"nf-home-service\", \"props\": {\"primaryColor\": \"#165dff\", \"priceColor\": \"#fe5200\", \"siteName\": \"正贤Api\", \"vipBanner\": \"/home-nsmao/vip-banner.png\", \"providerLogo\": \"/default-avatar.svg\", \"sectionSub\": \"企业服务商\", \"sectionTitle\": \"优质服务商推荐\", \"providers\": [{\"name\": \"数据工坊\", \"avatar\": \"/home-nsmao/provider-logo.png\", \"isOfficial\": true, \"count\": \"128\", \"biz\": \"数据接口\", \"link\": \"/apilist\"}, {\"name\": \"智算云\", \"avatar\": \"/home-nsmao/provider-logo.png\", \"isOfficial\": false, \"count\": \"96\", \"biz\": \"AI服务\", \"link\": \"/apilist\"}, {\"name\": \"极客API\", \"avatar\": \"/home-nsmao/provider-logo.png\", \"isOfficial\": true, \"count\": \"73\", \"biz\": \"工具服务\", \"link\": \"/apilist\"}, {\"name\": \"万象数据\", \"avatar\": \"/home-nsmao/provider-logo.png\", \"isOfficial\": false, \"count\": \"52\", \"biz\": \"内容服务\", \"link\": \"/apilist\"}], \"dataSource\": \"auto\"}, \"children\": []}, {\"id\": \"home_join\", \"label\": \"入驻流程区\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 0, \"wrap\": false, \"style\": {\"background\": \"#fff\", \"borderRadius\": \"12px\", \"padding\": \"36px 0\", \"marginBottom\": \"24px\"}}, \"children\": [{\"id\": \"home_join_inner\", \"label\": \"区块内容容器\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 0, \"wrap\": false, \"style\": {\"width\": \"min(1280px, calc(100% - 32px))\", \"margin\": \"0 auto\"}}, \"children\": [{\"id\": \"home_join_head\", \"label\": \"区块标题\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"center\", \"align\": \"center\", \"gap\": 6, \"wrap\": false, \"style\": {\"marginBottom\": \"22px\"}}, \"children\": [{\"id\": \"home_join_sub\", \"label\": \"小标题\", \"type\": \"text\", \"props\": {\"content\": \"开店流程\", \"style\": {\"fontSize\": \"13px\", \"fontWeight\": 600, \"color\": \"#165dff\", \"letterSpacing\": \"0.08em\"}}}, {\"id\": \"home_join_title\", \"label\": \"大标题\", \"type\": \"title\", \"props\": {\"content\": \"申请成为服务商\", \"level\": 2, \"style\": {\"fontSize\": \"28px\", \"fontWeight\": 800, \"color\": \"#1d2129\", \"margin\": 0}}}]}, {\"id\": \"home_join_steps\", \"label\": \"流程步骤行\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 8, \"wrap\": false, \"style\": {\"marginBottom\": \"8px\"}}, \"children\": [{\"id\": \"home_join_step_1\", \"label\": \"步骤1\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 0, \"wrap\": false, \"style\": {\"position\": \"relative\", \"flex\": \"1 1 0\", \"minWidth\": 0, \"padding\": \"0 24px\", \"textAlign\": \"center\", \"fontSize\": \"12px\", \"lineHeight\": \"16px\"}}, \"children\": [{\"id\": \"home_join_step_img_1\", \"label\": \"步骤1配图\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/business-join-1.svg\", \"style\": {\"display\": \"block\", \"width\": \"102px\", \"height\": \"102px\", \"margin\": \"0 auto 14px\", \"borderRadius\": \"50%\"}}}, {\"id\": \"home_join_step_h_1\", \"label\": \"步骤1标题\", \"type\": \"title\", \"props\": {\"content\": \"第一步.提交申请\", \"level\": 3, \"style\": {\"margin\": 0, \"fontSize\": \"15px\", \"fontWeight\": 700, \"color\": \"#2b2b2b\"}}}, {\"id\": \"home_join_step_time_1\", \"label\": \"步骤1耗时\", \"type\": \"text\", \"props\": {\"content\": \"约5分钟\", \"style\": {\"marginTop\": \"14px\", \"padding\": \"2px 8px\", \"fontSize\": \"12px\", \"color\": \"#85878c\", \"background\": \"#f9f9fa\", \"borderRadius\": \"10px\"}}}, {\"id\": \"home_join_step_desc_1\", \"label\": \"步骤1描述\", \"type\": \"paragraph\", \"props\": {\"content\": \"填写基本信息提交入驻申请\", \"style\": {\"margin\": \"12px 0 0\", \"fontSize\": \"12px\", \"color\": \"#85878c\", \"textAlign\": \"center\"}}}, {\"id\": \"home_join_arrow_1\", \"label\": \"步骤1箭头\", \"type\": \"text\", \"props\": {\"content\": \"›\", \"style\": {\"position\": \"absolute\", \"top\": \"50px\", \"right\": \"-14px\", \"fontSize\": \"26px\", \"lineHeight\": 1, \"color\": \"rgba(22, 93, 255, 0.35)\"}}}]}, {\"id\": \"home_join_step_2\", \"label\": \"步骤2\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 0, \"wrap\": false, \"style\": {\"position\": \"relative\", \"flex\": \"1 1 0\", \"minWidth\": 0, \"padding\": \"0 24px\", \"textAlign\": \"center\", \"fontSize\": \"12px\", \"lineHeight\": \"16px\"}}, \"children\": [{\"id\": \"home_join_step_img_2\", \"label\": \"步骤2配图\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/business-join-2.svg\", \"style\": {\"display\": \"block\", \"width\": \"102px\", \"height\": \"102px\", \"margin\": \"0 auto 14px\", \"borderRadius\": \"50%\"}}}, {\"id\": \"home_join_step_h_2\", \"label\": \"步骤2标题\", \"type\": \"title\", \"props\": {\"content\": \"第二步.账户验证\", \"level\": 3, \"style\": {\"margin\": 0, \"fontSize\": \"15px\", \"fontWeight\": 700, \"color\": \"#2b2b2b\"}}}, {\"id\": \"home_join_step_time_2\", \"label\": \"步骤2耗时\", \"type\": \"text\", \"props\": {\"content\": \"约10分钟\", \"style\": {\"marginTop\": \"14px\", \"padding\": \"2px 8px\", \"fontSize\": \"12px\", \"color\": \"#85878c\", \"background\": \"#f9f9fa\", \"borderRadius\": \"10px\"}}}, {\"id\": \"home_join_step_desc_2\", \"label\": \"步骤2描述\", \"type\": \"paragraph\", \"props\": {\"content\": \"联网非留存身份验证\", \"style\": {\"margin\": \"12px 0 0\", \"fontSize\": \"12px\", \"color\": \"#85878c\", \"textAlign\": \"center\"}}}, {\"id\": \"home_join_arrow_2\", \"label\": \"步骤2箭头\", \"type\": \"text\", \"props\": {\"content\": \"›\", \"style\": {\"position\": \"absolute\", \"top\": \"50px\", \"right\": \"-14px\", \"fontSize\": \"26px\", \"lineHeight\": 1, \"color\": \"rgba(22, 93, 255, 0.35)\"}}}]}, {\"id\": \"home_join_step_3\", \"label\": \"步骤3\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 0, \"wrap\": false, \"style\": {\"position\": \"relative\", \"flex\": \"1 1 0\", \"minWidth\": 0, \"padding\": \"0 24px\", \"textAlign\": \"center\", \"fontSize\": \"12px\", \"lineHeight\": \"16px\"}}, \"children\": [{\"id\": \"home_join_step_img_3\", \"label\": \"步骤3配图\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/business-join-3.svg\", \"style\": {\"display\": \"block\", \"width\": \"102px\", \"height\": \"102px\", \"margin\": \"0 auto 14px\", \"borderRadius\": \"50%\"}}}, {\"id\": \"home_join_step_h_3\", \"label\": \"步骤3标题\", \"type\": \"title\", \"props\": {\"content\": \"第三步.平台审核\", \"level\": 3, \"style\": {\"margin\": 0, \"fontSize\": \"15px\", \"fontWeight\": 700, \"color\": \"#2b2b2b\"}}}, {\"id\": \"home_join_step_time_3\", \"label\": \"步骤3耗时\", \"type\": \"text\", \"props\": {\"content\": \"约1-5个工作日\", \"style\": {\"marginTop\": \"14px\", \"padding\": \"2px 8px\", \"fontSize\": \"12px\", \"color\": \"#85878c\", \"background\": \"#f9f9fa\", \"borderRadius\": \"10px\"}}}, {\"id\": \"home_join_step_desc_3\", \"label\": \"步骤3描述\", \"type\": \"paragraph\", \"props\": {\"content\": \"平台进行资质审核\", \"style\": {\"margin\": \"12px 0 0\", \"fontSize\": \"12px\", \"color\": \"#85878c\", \"textAlign\": \"center\"}}}, {\"id\": \"home_join_arrow_3\", \"label\": \"步骤3箭头\", \"type\": \"text\", \"props\": {\"content\": \"›\", \"style\": {\"position\": \"absolute\", \"top\": \"50px\", \"right\": \"-14px\", \"fontSize\": \"26px\", \"lineHeight\": 1, \"color\": \"rgba(22, 93, 255, 0.35)\"}}}]}, {\"id\": \"home_join_step_4\", \"label\": \"步骤4\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 0, \"wrap\": false, \"style\": {\"position\": \"relative\", \"flex\": \"1 1 0\", \"minWidth\": 0, \"padding\": \"0 24px\", \"textAlign\": \"center\", \"fontSize\": \"12px\", \"lineHeight\": \"16px\"}}, \"children\": [{\"id\": \"home_join_step_img_4\", \"label\": \"步骤4配图\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/business-join-4.svg\", \"style\": {\"display\": \"block\", \"width\": \"102px\", \"height\": \"102px\", \"margin\": \"0 auto 14px\", \"borderRadius\": \"50%\"}}}, {\"id\": \"home_join_step_h_4\", \"label\": \"步骤4标题\", \"type\": \"title\", \"props\": {\"content\": \"第四步.店铺开通\", \"level\": 3, \"style\": {\"margin\": 0, \"fontSize\": \"15px\", \"fontWeight\": 700, \"color\": \"#2b2b2b\"}}}, {\"id\": \"home_join_step_time_4\", \"label\": \"步骤4耗时\", \"type\": \"text\", \"props\": {\"content\": \"约1-7个工作日\", \"style\": {\"marginTop\": \"14px\", \"padding\": \"2px 8px\", \"fontSize\": \"12px\", \"color\": \"#85878c\", \"background\": \"#f9f9fa\", \"borderRadius\": \"10px\"}}}, {\"id\": \"home_join_step_desc_4\", \"label\": \"步骤4描述\", \"type\": \"paragraph\", \"props\": {\"content\": \"通过协议，可上传发布API管理付费\", \"style\": {\"margin\": \"12px 0 0\", \"fontSize\": \"12px\", \"color\": \"#85878c\", \"textAlign\": \"center\"}}}]}]}, {\"id\": \"home_join_action\", \"label\": \"入驻按钮区\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"center\", \"align\": \"center\", \"gap\": 0, \"wrap\": false, \"style\": {\"width\": \"100%\"}}, \"children\": [{\"id\": \"home_join_btn\", \"label\": \"申请入驻 →\", \"type\": \"button\", \"props\": {\"type\": \"primary\", \"style\": {\"height\": \"44px\", \"padding\": \"0 28px\", \"fontSize\": \"15px\", \"fontWeight\": 600, \"borderRadius\": \"6px\", \"background\": \"#165dff\"}}, \"on\": {\"click\": [{\"methodName\": \"navigatePrimary\", \"args\": \"[]\", \"type\": \"public\"}]}}]}]}]}, {\"id\": \"home_code\", \"label\": \"API管理流程区\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 0, \"wrap\": false, \"style\": {\"marginBottom\": \"48px\", \"background\": \"#ffffff\"}}, \"children\": [{\"id\": \"home_code_inner\", \"label\": \"区块内容容器\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 0, \"wrap\": false, \"style\": {\"width\": \"min(1280px, calc(100% - 32px))\", \"margin\": \"0 auto\"}}, \"children\": [{\"id\": \"home_code_head\", \"label\": \"区块标题\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"center\", \"align\": \"center\", \"gap\": 6, \"wrap\": false, \"style\": {\"marginBottom\": \"22px\"}}, \"children\": [{\"id\": \"home_code_sub\", \"label\": \"小标题\", \"type\": \"text\", \"props\": {\"content\": \"多语言支持\", \"style\": {\"fontSize\": \"13px\", \"fontWeight\": 600, \"color\": \"#165dff\", \"letterSpacing\": \"0.08em\"}}}, {\"id\": \"home_code_title\", \"label\": \"大标题\", \"type\": \"title\", \"props\": {\"content\": \"API管理流程\", \"level\": 2, \"style\": {\"fontSize\": \"28px\", \"fontWeight\": 800, \"color\": \"#1d2129\", \"margin\": 0}}}]}, {\"id\": \"home_code_grid\", \"label\": \"左右分栏\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 18, \"wrap\": false}, \"children\": [{\"id\": \"home_code_left\", \"label\": \"左栏\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 0, \"wrap\": false}, \"children\": [{\"id\": \"home_code_langs\", \"label\": \"语言卡片网格\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 14, \"wrap\": true}, \"children\": [{\"id\": \"home_code_lang_golang\", \"label\": \"Goland卡片\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 12, \"wrap\": false, \"style\": {\"height\": \"106px\", \"padding\": \"22px\", \"boxSizing\": \"border-box\", \"background\": \"linear-gradient(#ffffffbf, #ffffff7a)\", \"borderRadius\": \"16px\", \"boxShadow\": \"3px 4px 20px #c3c3d23d\", \"flex\": \"1 1 calc(50% - 7px)\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_golang_icon\", \"label\": \"Goland图标\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/lang-golang.svg\", \"style\": {\"width\": \"44px\", \"height\": \"44px\", \"flex\": \"0 0 auto\"}}}, {\"id\": \"home_code_lang_golang_txt\", \"label\": \"Goland文字\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 4, \"wrap\": false, \"style\": {\"marginLeft\": \"12px\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_golang_h\", \"label\": \"Goland名称\", \"type\": \"title\", \"props\": {\"content\": \"Goland\", \"level\": 5, \"style\": {\"margin\": 0, \"fontSize\": \"18px\", \"fontWeight\": 700, \"color\": \"#121212\"}}}, {\"id\": \"home_code_lang_golang_p\", \"label\": \"Goland扩展名\", \"type\": \"text\", \"props\": {\"content\": \".go\", \"style\": {\"margin\": 0, \"fontSize\": \"13px\", \"color\": \"#85878c\"}}}]}]}, {\"id\": \"home_code_lang_php\", \"label\": \"PHP卡片\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 12, \"wrap\": false, \"style\": {\"height\": \"106px\", \"padding\": \"22px\", \"boxSizing\": \"border-box\", \"background\": \"linear-gradient(#ffffffbf, #ffffff7a)\", \"borderRadius\": \"16px\", \"boxShadow\": \"3px 4px 20px #c3c3d23d\", \"flex\": \"1 1 calc(50% - 7px)\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_php_icon\", \"label\": \"PHP图标\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/lang-php.svg\", \"style\": {\"width\": \"44px\", \"height\": \"44px\", \"flex\": \"0 0 auto\"}}}, {\"id\": \"home_code_lang_php_txt\", \"label\": \"PHP文字\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 4, \"wrap\": false, \"style\": {\"marginLeft\": \"12px\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_php_h\", \"label\": \"PHP名称\", \"type\": \"title\", \"props\": {\"content\": \"PHP\", \"level\": 5, \"style\": {\"margin\": 0, \"fontSize\": \"18px\", \"fontWeight\": 700, \"color\": \"#121212\"}}}, {\"id\": \"home_code_lang_php_p\", \"label\": \"PHP扩展名\", \"type\": \"text\", \"props\": {\"content\": \".php\", \"style\": {\"margin\": 0, \"fontSize\": \"13px\", \"color\": \"#85878c\"}}}]}]}, {\"id\": \"home_code_lang_java\", \"label\": \"Java卡片\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 12, \"wrap\": false, \"style\": {\"height\": \"106px\", \"padding\": \"22px\", \"boxSizing\": \"border-box\", \"background\": \"linear-gradient(#ffffffbf, #ffffff7a)\", \"borderRadius\": \"16px\", \"boxShadow\": \"3px 4px 20px #c3c3d23d\", \"flex\": \"1 1 calc(50% - 7px)\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_java_icon\", \"label\": \"Java图标\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/lang-java.svg\", \"style\": {\"width\": \"44px\", \"height\": \"44px\", \"flex\": \"0 0 auto\"}}}, {\"id\": \"home_code_lang_java_txt\", \"label\": \"Java文字\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 4, \"wrap\": false, \"style\": {\"marginLeft\": \"12px\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_java_h\", \"label\": \"Java名称\", \"type\": \"title\", \"props\": {\"content\": \"Java\", \"level\": 5, \"style\": {\"margin\": 0, \"fontSize\": \"18px\", \"fontWeight\": 700, \"color\": \"#121212\"}}}, {\"id\": \"home_code_lang_java_p\", \"label\": \"Java扩展名\", \"type\": \"text\", \"props\": {\"content\": \".java\", \"style\": {\"margin\": 0, \"fontSize\": \"13px\", \"color\": \"#85878c\"}}}]}]}, {\"id\": \"home_code_lang_python\", \"label\": \"Python卡片\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 12, \"wrap\": false, \"style\": {\"height\": \"106px\", \"padding\": \"22px\", \"boxSizing\": \"border-box\", \"background\": \"linear-gradient(#ffffffbf, #ffffff7a)\", \"borderRadius\": \"16px\", \"boxShadow\": \"3px 4px 20px #c3c3d23d\", \"flex\": \"1 1 calc(50% - 7px)\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_python_icon\", \"label\": \"Python图标\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/lang-python.svg\", \"style\": {\"width\": \"44px\", \"height\": \"44px\", \"flex\": \"0 0 auto\"}}}, {\"id\": \"home_code_lang_python_txt\", \"label\": \"Python文字\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 4, \"wrap\": false, \"style\": {\"marginLeft\": \"12px\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_python_h\", \"label\": \"Python名称\", \"type\": \"title\", \"props\": {\"content\": \"Python\", \"level\": 5, \"style\": {\"margin\": 0, \"fontSize\": \"18px\", \"fontWeight\": 700, \"color\": \"#121212\"}}}, {\"id\": \"home_code_lang_python_p\", \"label\": \"Python扩展名\", \"type\": \"text\", \"props\": {\"content\": \".py\", \"style\": {\"margin\": 0, \"fontSize\": \"13px\", \"color\": \"#85878c\"}}}]}]}, {\"id\": \"home_code_lang_nodejs\", \"label\": \"Node.js卡片\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 12, \"wrap\": false, \"style\": {\"height\": \"106px\", \"padding\": \"22px\", \"boxSizing\": \"border-box\", \"background\": \"linear-gradient(#ffffffbf, #ffffff7a)\", \"borderRadius\": \"16px\", \"boxShadow\": \"3px 4px 20px #c3c3d23d\", \"flex\": \"1 1 calc(50% - 7px)\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_nodejs_icon\", \"label\": \"Node.js图标\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/lang-nodejs.svg\", \"style\": {\"width\": \"44px\", \"height\": \"44px\", \"flex\": \"0 0 auto\"}}}, {\"id\": \"home_code_lang_nodejs_txt\", \"label\": \"Node.js文字\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 4, \"wrap\": false, \"style\": {\"marginLeft\": \"12px\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_nodejs_h\", \"label\": \"Node.js名称\", \"type\": \"title\", \"props\": {\"content\": \"Node.js\", \"level\": 5, \"style\": {\"margin\": 0, \"fontSize\": \"18px\", \"fontWeight\": 700, \"color\": \"#121212\"}}}, {\"id\": \"home_code_lang_nodejs_p\", \"label\": \"Node.js扩展名\", \"type\": \"text\", \"props\": {\"content\": \".js\", \"style\": {\"margin\": 0, \"fontSize\": \"13px\", \"color\": \"#85878c\"}}}]}]}, {\"id\": \"home_code_lang_swift\", \"label\": \"Swift卡片\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 12, \"wrap\": false, \"style\": {\"height\": \"106px\", \"padding\": \"22px\", \"boxSizing\": \"border-box\", \"background\": \"linear-gradient(#ffffffbf, #ffffff7a)\", \"borderRadius\": \"16px\", \"boxShadow\": \"3px 4px 20px #c3c3d23d\", \"flex\": \"1 1 calc(50% - 7px)\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_swift_icon\", \"label\": \"Swift图标\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/lang-swift.svg\", \"style\": {\"width\": \"44px\", \"height\": \"44px\", \"flex\": \"0 0 auto\"}}}, {\"id\": \"home_code_lang_swift_txt\", \"label\": \"Swift文字\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 4, \"wrap\": false, \"style\": {\"marginLeft\": \"12px\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_swift_h\", \"label\": \"Swift名称\", \"type\": \"title\", \"props\": {\"content\": \"Swift\", \"level\": 5, \"style\": {\"margin\": 0, \"fontSize\": \"18px\", \"fontWeight\": 700, \"color\": \"#121212\"}}}, {\"id\": \"home_code_lang_swift_p\", \"label\": \"Swift扩展名\", \"type\": \"text\", \"props\": {\"content\": \".swift\", \"style\": {\"margin\": 0, \"fontSize\": \"13px\", \"color\": \"#85878c\"}}}]}]}, {\"id\": \"home_code_lang_cs\", \"label\": \"C#卡片\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 12, \"wrap\": false, \"style\": {\"height\": \"106px\", \"padding\": \"22px\", \"boxSizing\": \"border-box\", \"background\": \"linear-gradient(#ffffffbf, #ffffff7a)\", \"borderRadius\": \"16px\", \"boxShadow\": \"3px 4px 20px #c3c3d23d\", \"flex\": \"1 1 calc(50% - 7px)\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_cs_icon\", \"label\": \"C#图标\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/lang-cs.svg\", \"style\": {\"width\": \"44px\", \"height\": \"44px\", \"flex\": \"0 0 auto\"}}}, {\"id\": \"home_code_lang_cs_txt\", \"label\": \"C#文字\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 4, \"wrap\": false, \"style\": {\"marginLeft\": \"12px\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_cs_h\", \"label\": \"C#名称\", \"type\": \"title\", \"props\": {\"content\": \"C#\", \"level\": 5, \"style\": {\"margin\": 0, \"fontSize\": \"18px\", \"fontWeight\": 700, \"color\": \"#121212\"}}}, {\"id\": \"home_code_lang_cs_p\", \"label\": \"C#扩展名\", \"type\": \"text\", \"props\": {\"content\": \".cs\", \"style\": {\"margin\": 0, \"fontSize\": \"13px\", \"color\": \"#85878c\"}}}]}]}, {\"id\": \"home_code_lang_javascript\", \"label\": \"Javascript卡片\", \"type\": \"flex\", \"props\": {\"vertical\": false, \"justify\": \"flex-start\", \"align\": \"center\", \"gap\": 12, \"wrap\": false, \"style\": {\"height\": \"106px\", \"padding\": \"22px\", \"boxSizing\": \"border-box\", \"background\": \"linear-gradient(#ffffffbf, #ffffff7a)\", \"borderRadius\": \"16px\", \"boxShadow\": \"3px 4px 20px #c3c3d23d\", \"flex\": \"1 1 calc(50% - 7px)\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_javascript_icon\", \"label\": \"Javascript图标\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/lang-javascript.svg\", \"style\": {\"width\": \"44px\", \"height\": \"44px\", \"flex\": \"0 0 auto\"}}}, {\"id\": \"home_code_lang_javascript_txt\", \"label\": \"Javascript文字\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 4, \"wrap\": false, \"style\": {\"marginLeft\": \"12px\", \"minWidth\": 0}}, \"children\": [{\"id\": \"home_code_lang_javascript_h\", \"label\": \"Javascript名称\", \"type\": \"title\", \"props\": {\"content\": \"Javascript\", \"level\": 5, \"style\": {\"margin\": 0, \"fontSize\": \"18px\", \"fontWeight\": 700, \"color\": \"#121212\"}}}, {\"id\": \"home_code_lang_javascript_p\", \"label\": \"Javascript扩展名\", \"type\": \"text\", \"props\": {\"content\": \".js\", \"style\": {\"margin\": 0, \"fontSize\": \"13px\", \"color\": \"#85878c\"}}}]}]}]}, {\"id\": \"home_code_note1\", \"label\": \"说明条\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 4, \"wrap\": false, \"style\": {\"margin\": \"14px 0 0\", \"padding\": \"12px 16px\", \"background\": \"rgba(22, 93, 255, 0.06)\", \"borderLeft\": \"3px solid #165dff\", \"borderRadius\": \"6px\"}}, \"children\": [{\"id\": \"home_code_note1_h\", \"label\": \"说明标题\", \"type\": \"text\", \"props\": {\"content\": \"API 支持\", \"style\": {\"margin\": 0, \"fontSize\": \"14px\", \"fontWeight\": 700, \"color\": \"#2b2b2b\"}}}, {\"id\": \"home_code_note1_p\", \"label\": \"说明内容\", \"type\": \"text\", \"props\": {\"content\": \"多种编程语言接入\", \"style\": {\"margin\": 0, \"fontSize\": \"13px\", \"color\": \"#85878c\"}}}]}]}, {\"id\": \"home_code_right\", \"label\": \"右栏\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 14, \"wrap\": false}, \"children\": [{\"id\": \"home_code_box_1\", \"label\": \"图片框1\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 0, \"wrap\": false, \"style\": {\"padding\": \"10px\", \"background\": \"#fff\", \"borderRadius\": \"16px\", \"boxShadow\": \"0 2px 12px rgba(0, 0, 0, 0.04)\"}}, \"children\": [{\"id\": \"home_code_img_1\", \"label\": \"流程图1\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/code-1.png\", \"style\": {\"display\": \"block\", \"width\": \"100%\", \"borderRadius\": \"12px\"}}}, {\"id\": \"home_code_note_1\", \"label\": \"说明条\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 4, \"wrap\": false, \"style\": {\"margin\": \"14px 0 0\", \"padding\": \"12px 16px\", \"background\": \"rgba(22, 93, 255, 0.06)\", \"borderLeft\": \"3px solid #165dff\", \"borderRadius\": \"6px\"}}, \"children\": [{\"id\": \"home_code_note_1_h\", \"label\": \"说明标题\", \"type\": \"text\", \"props\": {\"content\": \"API 对接\", \"style\": {\"margin\": 0, \"fontSize\": \"14px\", \"fontWeight\": 700, \"color\": \"#2b2b2b\"}}}, {\"id\": \"home_code_note_1_p\", \"label\": \"说明内容\", \"type\": \"text\", \"props\": {\"content\": \"流程化数据验证接入\", \"style\": {\"margin\": 0, \"fontSize\": \"13px\", \"color\": \"#85878c\"}}}]}]}, {\"id\": \"home_code_box_2\", \"label\": \"图片框2\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 0, \"wrap\": false, \"style\": {\"padding\": \"10px\", \"background\": \"#fff\", \"borderRadius\": \"16px\", \"boxShadow\": \"0 2px 12px rgba(0, 0, 0, 0.04)\"}}, \"children\": [{\"id\": \"home_code_img_2\", \"label\": \"流程图2\", \"type\": \"image\", \"props\": {\"src\": \"/api/epic-runtime/home-nsmao/code-2.png\", \"style\": {\"display\": \"block\", \"width\": \"100%\", \"borderRadius\": \"12px\"}}}, {\"id\": \"home_code_note_2\", \"label\": \"说明条\", \"type\": \"flex\", \"props\": {\"vertical\": true, \"justify\": \"flex-start\", \"align\": \"stretch\", \"gap\": 4, \"wrap\": false, \"style\": {\"margin\": \"14px 0 0\", \"padding\": \"12px 16px\", \"background\": \"rgba(22, 93, 255, 0.06)\", \"borderLeft\": \"3px solid #165dff\", \"borderRadius\": \"6px\"}}, \"children\": [{\"id\": \"home_code_note_2_h\", \"label\": \"说明标题\", \"type\": \"text\", \"props\": {\"content\": \"API 售后\", \"style\": {\"margin\": 0, \"fontSize\": \"14px\", \"fontWeight\": 700, \"color\": \"#2b2b2b\"}}}, {\"id\": \"home_code_note_2_p\", \"label\": \"说明内容\", \"type\": \"text\", \"props\": {\"content\": \"团队专业技术支持\", \"style\": {\"margin\": 0, \"fontSize\": \"13px\", \"color\": \"#85878c\"}}}]}]}]}]}]}]}, {\"id\": \"home_doc_head\", \"label\": \"文档区标题\", \"type\": \"flex\", \"props\": {\"align\": \"center\", \"gap\": 6, \"justify\": \"center\", \"vertical\": true, \"wrap\": false, \"style\": {\"margin\": \"8px 0 22px\"}}, \"children\": [{\"id\": \"home_doc_sub\", \"label\": \"小标题\", \"type\": \"text\", \"props\": {\"content\": \"快速上手\", \"style\": {\"color\": \"#165dff\", \"fontSize\": \"13px\", \"fontWeight\": 600, \"letterSpacing\": \"0.08em\"}}}, {\"id\": \"home_doc_title\", \"label\": \"大标题\", \"type\": \"title\", \"props\": {\"content\": \"API全新动态\", \"level\": 2, \"style\": {\"fontSize\": \"28px\", \"fontWeight\": 800, \"margin\": \"0\"}}}]}, {\"id\": \"home_doc_row\", \"label\": \"文档卡三列\", \"type\": \"flex\", \"props\": {\"align\": \"stretch\", \"gap\": 18, \"justify\": \"flex-start\", \"vertical\": false, \"wrap\": false, \"style\": {\"margin\": \"0 auto 56px\", \"width\": \"min(1280px, calc(100% - 32px))\"}}, \"children\": [{\"id\": \"home_doc_card_1\", \"label\": \"常见问题卡\", \"type\": \"nf-doc-card\", \"props\": {\"bodyHeight\": \"290px\", \"headerCn\": \"常见问题 | Normal Problem\", \"headerEn\": \"Normal Problem\", \"headerImage\": \"/home-nsmao/doc-header-1.png\", \"items\": [{\"answer\": \"接口统一返回 code/data/msg 结构，错误时携带错误码与错误消息，按错误码判断类型：400 检查请求参数，401 检查API密钥，403 确认账户权限，404 检查请求地址，500 稍后重试或联系支持。\", \"date\": \"06-09\", \"title\": \"如何处理API返回的错误信息？\"}, {\"answer\": \"返回为 JSON 结构，包含 code 状态码、data 业务数据与 msg 提示信息。\", \"date\": \"06-08\", \"title\": \"API返回数据格式是什么？\"}, {\"answer\": \"可升级会员套餐获得更高的每秒请求上限，或在控制台查看当前速率配置。\", \"date\": \"06-07\", \"title\": \"如何提高API请求的速率限制？\"}, {\"answer\": \"检查请求头是否携带有效的 Nice-Apikey，并确认 Key 状态与接口权限。\", \"date\": \"06-05\", \"title\": \"API请求失败，返回401未授权错误，怎么办？\"}, {\"answer\": \"注册登录后在控制台「Key管理」中创建全站 Key 或接口专属 Key。\", \"date\": \"06-03\", \"title\": \"如何获取API密钥？\"}], \"style\": {\"flex\": \"1 1 0\", \"minWidth\": \"0\"}, \"dataSource\": \"auto\", \"categoryCode\": \"faq\"}}, {\"id\": \"home_doc_card_2\", \"label\": \"公司新闻卡\", \"type\": \"nf-doc-card\", \"props\": {\"bodyHeight\": \"290px\", \"headerCn\": \"公司新闻 | Company Dynamics\", \"headerEn\": \"Company Dynamics\", \"headerImage\": \"/home-nsmao/doc-header-2.png\", \"items\": [{\"answer\": \"为了更好地支持开发者，平台推出API开发者支持计划，提供详细的API文档与多商户服务，帮助企业提高营收与曝光量。\", \"date\": \"06-09\", \"title\": \"平台推出开发者支持计划\"}, {\"answer\": \"多起接入案例已完成沉淀，覆盖数据查询、内容识别等典型场景。\", \"date\": \"06-06\", \"title\": \"API集成成功案例分享\"}, {\"answer\": \"新版接口在数据处理链路上做了优化，平均响应耗时进一步降低。\", \"date\": \"06-02\", \"title\": \"发布新版API，提升数据处理速度\"}, {\"answer\": \"与多家平台达成合作，接口生态持续扩大。\", \"date\": \"05-28\", \"title\": \"达成生态合作\"}], \"style\": {\"flex\": \"1 1 0\", \"minWidth\": \"0\"}, \"dataSource\": \"auto\", \"categoryCode\": \"company\"}}, {\"id\": \"home_doc_card_3\", \"label\": \"行业新闻卡\", \"type\": \"nf-doc-card\", \"props\": {\"bodyHeight\": \"290px\", \"headerCn\": \"行业新闻 | Industry News\", \"headerEn\": \"Industry News\", \"headerImage\": \"/home-nsmao/doc-header-3.png\", \"items\": [{\"answer\": \"越来越多平台按实际调用量结算，开发者只为真实用量付费，接入成本更透明可控。\", \"date\": \"06-09\", \"title\": \"接口按量计费成为主流\"}, {\"answer\": \"密钥签名、IP 白名单与请求加密逐步成为接入标配，调用链路更安全。\", \"date\": \"06-04\", \"title\": \"接口鉴权与加密成接入标配\"}, {\"answer\": \"企业更倾向通过统一入口聚合多家服务商接口，减少重复对接与维护成本。\", \"date\": \"05-30\", \"title\": \"多商户接口聚合需求上升\"}, {\"answer\": \"可用率与响应耗时成为选型关键指标，稳定服务成为核心竞争力。\", \"date\": \"05-21\", \"title\": \"接口可用率成为选型硬指标\"}], \"style\": {\"flex\": \"1 1 0\", \"minWidth\": \"0\"}, \"dataSource\": \"auto\", \"categoryCode\": \"industry\"}}]}]}], \"canvas\": {\"mode\": \"desktop\", \"width\": 1280}}',1,0,NULL,1,'2026-08-30 20:55:28','2026-10-12 17:41:17',0,NULL),(23,'market-official','/apilist',1,'{\"schemas\":[{\"id\":\"market_root\",\"label\":\"市场页面\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\"},\"type\":\"flex\",\"children\":[{\"id\":\"nf_market_banner\",\"label\":\"市场Banner搜索\",\"type\":\"nf-market-banner\",\"props\":{\"bannerDesc\":\"API市场是一个开放的API交易市场，这里有各种各样的API接口，可以满足你的各种需求。\",\"bannerImage\":\"/home-nsmao/market-banner.jpg\",\"bannerTitle\":\"API市场\",\"placeholder\":\"搜索相关API接口..\"}},{\"id\":\"nf_market_category\",\"label\":\"市场分类栏\",\"type\":\"nf-category-bar\",\"props\":{}},{\"id\":\"market_grid_area\",\"label\":\"接口列表区\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"background\":\"#fff\",\"paddingBottom\":\"48px\"}},\"children\":[{\"id\":\"nf_market_grid\",\"label\":\"接口卡片网格\",\"type\":\"nf-api-grid\",\"props\":{}}]}]}],\"canvas\":{\"mode\":\"desktop\",\"width\":1280}}','接口市场(官方)','接口市场官方可视化版本：市场 Banner 与关键词搜索、接口分类栏筛选、接口卡片网格列表（分类切换、分页浏览、点击进入接口详情）','{\"schemas\":[{\"id\":\"market_root\",\"label\":\"市场页面\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\"},\"type\":\"flex\",\"children\":[{\"id\":\"nf_market_banner\",\"label\":\"市场Banner搜索\",\"type\":\"nf-market-banner\",\"props\":{\"bannerDesc\":\"API市场是一个开放的API交易市场，这里有各种各样的API接口，可以满足你的各种需求。\",\"bannerImage\":\"/home-nsmao/market-banner.jpg\",\"bannerTitle\":\"API市场\",\"placeholder\":\"搜索相关API接口..\"}},{\"id\":\"nf_market_category\",\"label\":\"市场分类栏\",\"type\":\"nf-category-bar\",\"props\":{}},{\"id\":\"market_grid_area\",\"label\":\"接口列表区\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"background\":\"#fff\",\"paddingBottom\":\"48px\"}},\"children\":[{\"id\":\"nf_market_grid\",\"label\":\"接口卡片网格\",\"type\":\"nf-api-grid\",\"props\":{}}]}]}],\"canvas\":{\"mode\":\"desktop\",\"width\":1280}}',1,0,1,NULL,'2026-09-04 20:14:22','2026-10-12 17:41:17',0,NULL),(24,'docs-official','/docs/:id',1,NULL,'接口文档(官方)','接口详情页官方可视化版本：接口产品区、页签导航、功能介绍、服务保障、使用流程、接口文档、示例代码、接口测试与术语抽屉','{\"schemas\":[{\"id\":\"docs_root\",\"label\":\"接口文档页\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"background\":\"#f7f8fb\",\"paddingTop\":\"16px\",\"paddingBottom\":\"48px\",\"paddingLeft\":\"16px\",\"paddingRight\":\"16px\",\"minHeight\":\"100vh\"}},\"children\":[{\"id\":\"nf_docs_hero\",\"label\":\"接口产品区\",\"type\":\"nf-docs-hero\",\"props\":{}},{\"id\":\"nf_docs_tabbar\",\"label\":\"接口页签导航\",\"type\":\"nf-docs-tabbar\",\"props\":{}},{\"id\":\"nf_docs_intro_group\",\"label\":\"功能介绍面板组\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"background\":\"#fff\",\"borderRadius\":\"0 0 3px 3px\",\"boxShadow\":\"rgba(215, 206, 255, 0.22) 3px 3px 20px 0\"}},\"children\":[{\"id\":\"nf_docs_intro\",\"label\":\"功能介绍\",\"type\":\"nf-docs-intro\",\"props\":{}},{\"id\":\"nf_docs_guarantees\",\"label\":\"服务保障面板\",\"type\":\"nf-docs-guarantees\",\"props\":{}},{\"id\":\"nf_docs_usage\",\"label\":\"使用流程\",\"type\":\"nf-docs-usage\",\"props\":{}}]},{\"id\":\"nf_docs_documentation\",\"label\":\"接口文档面板\",\"type\":\"nf-docs-documentation\",\"props\":{}},{\"id\":\"nf_docs_examples\",\"label\":\"示例代码面板\",\"type\":\"nf-docs-examples\",\"props\":{}},{\"id\":\"nf_docs_test\",\"label\":\"接口测试面板\",\"type\":\"nf-docs-test\",\"props\":{}},{\"id\":\"nf_docs_glossary\",\"label\":\"术语抽屉\",\"type\":\"nf-docs-glossary\",\"props\":{}}]}],\"canvas\":{\"mode\":\"desktop\",\"width\":1280}}',1,0,NULL,NULL,'2026-09-04 21:22:43','2026-10-12 17:41:17',0,NULL),(25,'shop-official','/provider-plaza/shop/:code',1,NULL,'服务商店铺(官方)','服务商店铺详情页官方可视化版本：店铺头部（店铺名称、资质信息与联系入口）、店铺接口卡片列表、店铺入驻信息侧栏','{\"schemas\":[{\"id\":\"shop_root\",\"label\":\"服务商店铺页\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"background\":\"#f7f8fb\",\"paddingTop\":\"16px\",\"paddingBottom\":\"48px\",\"minHeight\":\"100vh\"}},\"children\":[{\"id\":\"shop_container\",\"label\":\"店铺内容容器\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"maxWidth\":\"1280px\",\"width\":\"calc(100% - 32px)\",\"margin\":\"0 auto\"}},\"children\":[{\"id\":\"nf_shop_hero\",\"label\":\"店铺头部\",\"type\":\"nf-shop-hero\",\"props\":{}},{\"id\":\"nf_shop_content\",\"label\":\"商品区\",\"type\":\"flex\",\"props\":{\"gap\":20,\"justify\":\"flex-start\",\"vertical\":false,\"wrap\":\"nowrap\",\"style\":{}},\"children\":[{\"id\":\"nf_shop_apis\",\"label\":\"店铺接口列表\",\"type\":\"nf-shop-apis\",\"props\":{}},{\"id\":\"nf_shop_aside\",\"label\":\"店铺入驻信息\",\"type\":\"nf-shop-aside\",\"props\":{}}]}]}]}],\"canvas\":{\"mode\":\"desktop\",\"width\":1280}}',1,0,NULL,NULL,'2026-09-04 23:27:46','2026-10-12 17:41:17',0,NULL),(26,'plaza-official','/provider-plaza',1,NULL,'服务商广场(官方)','服务商广场页官方可视化版本：我的服务数据看板、服务商列表、服务商排行榜、API 接口推荐','{\"schemas\":[{\"id\":\"plaza_root\",\"label\":\"服务商广场页\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"paddingTop\":\"32px\",\"paddingBottom\":\"32px\",\"minHeight\":\"100vh\",\"background\":\"#f5f6fa\"}},\"children\":[{\"id\":\"plaza_shell\",\"label\":\"广场内容区\",\"type\":\"flex\",\"props\":{\"gap\":16,\"justify\":\"flex-start\",\"vertical\":false,\"wrap\":\"wrap\",\"align\":\"stretch\",\"style\":{\"maxWidth\":\"1280px\",\"width\":\"calc(100% - 32px)\",\"margin\":\"0 auto\"}},\"children\":[{\"id\":\"plaza_main\",\"label\":\"主内容列\",\"type\":\"flex\",\"props\":{\"gap\":16,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"flex\":\"1 1 620px\",\"minWidth\":\"0\"}},\"children\":[{\"id\":\"nf_plaza_stats\",\"label\":\"我的服务数据\",\"type\":\"nf-plaza-stats\",\"props\":{}},{\"id\":\"nf_plaza_list\",\"label\":\"服务商列表\",\"type\":\"nf-plaza-list\",\"props\":{}}]},{\"id\":\"plaza_side\",\"label\":\"侧边栏\",\"type\":\"flex\",\"props\":{\"gap\":16,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"flex\":\"0 0 300px\"}},\"children\":[{\"id\":\"nf_plaza_rank\",\"label\":\"服务商排行榜\",\"type\":\"nf-plaza-rank\",\"props\":{}},{\"id\":\"nf_plaza_apis\",\"label\":\"API接口推荐\",\"type\":\"nf-plaza-apis\",\"props\":{}}]}]}]}],\"canvas\":{\"mode\":\"desktop\",\"width\":1280}}',1,0,NULL,1,'2026-09-04 23:55:34','2026-10-12 17:41:17',0,NULL),(27,'vip-official','/vip',1,NULL,'会员价格(官方)','会员价格页官方可视化版本：会员价格头图、全站套餐（按档位选择每日配额与并发）、会员权益、点数充值、常见问题','{\"schemas\":[{\"id\":\"vip_root\",\"label\":\"会员价格页\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"background\":\"#ffffff\",\"minHeight\":\"100vh\"}},\"children\":[{\"id\":\"nf_vip_hero\",\"label\":\"会员价格头图\",\"type\":\"nf-vip-hero\",\"props\":{\"badgeText\":\"VIP\",\"subtitle\":\"一次开通，全站接口通用；按档位选择每日配额与并发，按需升级\",\"title\":\"会员价格\",\"bgImage\":\"/home-nsmao/vip-hero-bg.png\"}},{\"id\":\"nf_vip_global\",\"label\":\"全站套餐\",\"type\":\"nf-vip-global\",\"props\":{\"sectionSubtitle\":\"一卡通吃全站接口，按需选择档位\",\"sectionTitle\":\"全站套餐\"}},{\"id\":\"nf_vip_benefits\",\"label\":\"会员权益\",\"type\":\"nf-vip-benefits\",\"props\":{\"sectionTitle\":\"会员权益\",\"sectionSubtitle\":\"面向个人开发者与团队：全站接口配额、专属限速与技术支持\",\"item1Title\":\"全站接口通用\",\"item1Desc\":\"开通后全站接口一键调用，无需逐个开通\",\"item2Title\":\"每日调用配额\",\"item2Desc\":\"按档位提供每日调用次数，旗舰档不限量\",\"item3Title\":\"专属 QPS 限速\",\"item3Desc\":\"更高并发额度，保障高峰期稳定调用\",\"item4Title\":\"点数按量计费\",\"item4Desc\":\"点数充值即到账，按接口单价扣费，不设有效期\",\"item5Title\":\"接口文档与示例\",\"item5Desc\":\"每个接口提供参数、返回字段与多语言调用示例\",\"item6Title\":\"专业工单支持\",\"item6Desc\":\"工单与站内信双通道，第一时间响应接入问题\",\"item7Title\":\"\",\"item7Desc\":\"\",\"item8Title\":\"\",\"item8Desc\":\"\"}},{\"id\":\"nf_vip_point\",\"label\":\"点数充值\",\"type\":\"nf-vip-point\",\"props\":{\"sectionSubtitle\":\"按量计费更灵活，充值即到账\",\"sectionTitle\":\"点数充值\"}},{\"id\":\"nf_vip_faq\",\"label\":\"常见问题\",\"type\":\"nf-vip-faq\",\"props\":{\"a1\":\"全站套餐一次开通即可调用全站所有接口，按档位提供每日调用配额与 QPS；接口套餐只针对单个接口单独购买规格。两者可同时拥有：调用时优先消耗全站套餐配额，全站套餐当日配额用尽或未开通时，才使用该接口对应的接口套餐配额。\",\"a2\":\"套餐到期后，该套餐提供的每日配额与 QPS 立即失效，需要重新开通才能恢复；账户内已充值的点数、以及尚未到期的其他套餐不受影响。\",\"a3\":\"每个接口可单独配置点数单价，按实际调用次数扣减账户点数；充值点数支付成功后立即到账，账户点数余额不设有效期。接口本身单价为 0 时，调用不扣点数。\",\"q1\":\"全站套餐和接口套餐有什么区别？\",\"q2\":\"套餐到期后还能继续调用吗？\",\"q3\":\"点数是怎么扣费的？会过期吗？\",\"sectionSubtitle\":\"以下是一些关于VIP会员的常见问题，如有其他问题请联系客服\",\"sectionTitle\":\"常见问题\"}}]}],\"canvas\":{\"mode\":\"desktop\",\"width\":1280},\"children\":[],\"props\":{\"style\":{\"background\":\"#ffffff\"}}}',1,0,NULL,NULL,'2026-09-05 15:06:07','2026-10-12 17:41:17',0,NULL),(28,'doc-official','/doc',1,NULL,'帮助文档(官方)','帮助文档首页官方可视化版本：文档中心头图与关键词搜索、最新文档列表、文档分类卡片','{\"schemas\":[{\"id\":\"doc_root\",\"label\":\"帮助文档页\",\"type\":\"flex\",\"props\":{\"gap\":0,\"justify\":\"flex-start\",\"vertical\":true,\"wrap\":\"nowrap\",\"style\":{\"background\":\"#ffffff\"}},\"children\":[{\"id\":\"nf_doc_hero\",\"label\":\"帮助文档头图\",\"type\":\"nf-doc-hero\",\"props\":{\"bgImage\":\"/home-nsmao/top-bg-7.png\",\"searchPlaceholder\":\"搜索文档标题或关键词\",\"subtitle\":\"按分类查找使用指南、接入教程与常见问题\",\"title\":\"文档中心\",\"compact\":false,\"showSearch\":true}},{\"id\":\"nf_doc_latest\",\"label\":\"最新文档\",\"type\":\"nf-doc-latest\",\"props\":{\"sectionTitle\":\"最新文档\",\"tagText\":\"NEW\"}},{\"id\":\"nf_doc_categories\",\"label\":\"文档分类卡片\",\"type\":\"nf-doc-categories\",\"props\":{\"sectionSubtitle\":\"\",\"sectionTitle\":\"文档分类\"}}]}],\"canvas\":{\"mode\":\"desktop\",\"width\":1280},\"children\":[],\"props\":{\"style\":{\"background\":\"#ffffff\"}}}',1,0,NULL,NULL,'2026-09-05 17:24:02','2026-10-12 17:41:17',0,NULL),(29,'doc-list-official','/doc/list/:code',1,NULL,'文档分类详情(官方)','帮助文档分类详情页官方可视化版本：文档中心头图与搜索框、左侧分类导航与右侧文档正文，支持搜索结果视图','{\"schemas\": [{\"id\": \"doc_list_root\", \"label\": \"文档分类详情页\", \"type\": \"flex\", \"props\": {\"gap\": 0, \"justify\": \"flex-start\", \"vertical\": true, \"wrap\": \"nowrap\", \"style\": {\"minHeight\": \"100vh\", \"background\": \"#f7f8fb\"}}, \"children\": [{\"id\": \"nf_doc_hero\", \"label\": \"帮助文档头图\", \"type\": \"nf-doc-hero\", \"props\": {\"bgImage\": \"\", \"searchPlaceholder\": \"搜索相关文档..\", \"showSearch\": false, \"subtitle\": \"解决方案、常见问题、您都可以在这里找到\", \"title\": \"文档中心\", \"compact\": true}}, {\"id\": \"nf_doc_list\", \"label\": \"文档分类详情\", \"type\": \"nf-doc-list\", \"props\": {\"emptyText\": \"该分类下暂无文档\", \"searchEmptyText\": \"没有找到相关文档\", \"searchTitle\": \"搜索结果\"}}]}], \"canvas\": {\"mode\": \"desktop\", \"width\": 1280}}',1,0,NULL,1,'2026-09-05 17:24:02','2026-10-12 17:41:17',0,NULL);
/*!40000 ALTER TABLE `sys_custom_page` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_payment_channel_config` WRITE;
/*!40000 ALTER TABLE `sys_payment_channel_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_payment_channel_config` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_oauth_client` WRITE;
/*!40000 ALTER TABLE `sys_oauth_client` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_oauth_client` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_interface_category` WRITE;
/*!40000 ALTER TABLE `sys_interface_category` DISABLE KEYS */;
INSERT INTO `sys_interface_category` VALUES (2,'JDK21测试分类','mingcute:fire-line',10,1,'2026-10-23 07:54:35','2026-10-23 07:54:35');
/*!40000 ALTER TABLE `sys_interface_category` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_ticket_group` WRITE;
/*!40000 ALTER TABLE `sys_ticket_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_ticket_group` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_ticket_sla_policy` WRITE;
/*!40000 ALTER TABLE `sys_ticket_sla_policy` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_ticket_sla_policy` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_report_template` WRITE;
/*!40000 ALTER TABLE `sys_report_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_report_template` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_dashboard_dataset` WRITE;
/*!40000 ALTER TABLE `sys_dashboard_dataset` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_dashboard_dataset` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_dashboard_layout` WRITE;
/*!40000 ALTER TABLE `sys_dashboard_layout` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_dashboard_layout` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_provider` WRITE;
/*!40000 ALTER TABLE `sys_provider` DISABLE KEYS */;
INSERT INTO `sys_provider` VALUES (7,1,'正贤Api平台','zhengxian','/api/upload/site-logo/039f29a1733a46c78207680ba349d417.png',NULL,'Official self-operated store providing platform-level stable interface services','admin@zhengxian.com',0.0000,0.0000,0.0000,1,1,NULL,NULL,NULL,'2026-08-17 17:06:58','2026-08-17 17:06:58','2026-10-11 03:31:00');
/*!40000 ALTER TABLE `sys_provider` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'zhengxian','$2a$10$/B0sia2lMNn5XyKvKIJyq.vpgMKCE7AtwQZAoMCvaS/mnt5A46kXy','管理员','/api/upload/site-logo/039f29a1733a46c78207680ba349d417.png',NULL,0,0,'',NULL,NULL,'/workspace',0.0000,0,0,1,1,NULL,0,NULL,NULL,NULL,0,NULL,NULL,0,0,NULL,NULL,'2026-07-26 20:15:11','2026-10-27 16:21:47',0.0000,0.0000,1,0);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(999005159,2),(1,3);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


SET FOREIGN_KEY_CHECKS=1;
