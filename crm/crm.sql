/*
Navicat MySQL Data Transfer

Source Server         : CRM
Source Server Version : 50738
Source Host           : localhost:3306
Source Database       : crm

Target Server Type    : MYSQL
Target Server Version : 50738
File Encoding         : 65001

Date: 2022-07-15 11:36:17
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `student`
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES ('1', '1');
INSERT INTO `student` VALUES ('2', '2');
INSERT INTO `student` VALUES ('3', '3');
INSERT INTO `student` VALUES ('4', '4');
INSERT INTO `student` VALUES ('5', '5');
INSERT INTO `student` VALUES ('6', '6');
INSERT INTO `student` VALUES ('7', '7');
INSERT INTO `student` VALUES ('8', '8');
INSERT INTO `student` VALUES ('9', '9');
INSERT INTO `student` VALUES ('10', '10');
INSERT INTO `student` VALUES ('11', '11');
INSERT INTO `student` VALUES ('12', '12');
INSERT INTO `student` VALUES ('13', '13');
INSERT INTO `student` VALUES ('14', '14');
INSERT INTO `student` VALUES ('15', '15');
INSERT INTO `student` VALUES ('16', '16');
INSERT INTO `student` VALUES ('17', '17');
INSERT INTO `student` VALUES ('18', '18');
INSERT INTO `student` VALUES ('19', '19');
INSERT INTO `student` VALUES ('20', '20');
INSERT INTO `student` VALUES ('21', '21');
INSERT INTO `student` VALUES ('22', '22');
INSERT INTO `student` VALUES ('23', '23');
INSERT INTO `student` VALUES ('24', '24');
INSERT INTO `student` VALUES ('25', '25');
INSERT INTO `student` VALUES ('26', '26');
INSERT INTO `student` VALUES ('27', '27');
INSERT INTO `student` VALUES ('28', '28');
INSERT INTO `student` VALUES ('29', '29');
INSERT INTO `student` VALUES ('30', '30');
INSERT INTO `student` VALUES ('31', '31');
INSERT INTO `student` VALUES ('32', '32');
INSERT INTO `student` VALUES ('33', '33');
INSERT INTO `student` VALUES ('34', '34');
INSERT INTO `student` VALUES ('35', '35');
INSERT INTO `student` VALUES ('36', '36');
INSERT INTO `student` VALUES ('37', '37');
INSERT INTO `student` VALUES ('38', '38');
INSERT INTO `student` VALUES ('39', '39');
INSERT INTO `student` VALUES ('40', '40');
INSERT INTO `student` VALUES ('41', '41');
INSERT INTO `student` VALUES ('42', '42');
INSERT INTO `student` VALUES ('43', '43');
INSERT INTO `student` VALUES ('44', '44');
INSERT INTO `student` VALUES ('45', '45');
INSERT INTO `student` VALUES ('46', '46');
INSERT INTO `student` VALUES ('47', '47');
INSERT INTO `student` VALUES ('48', '48');
INSERT INTO `student` VALUES ('49', '49');
INSERT INTO `student` VALUES ('50', '50');
INSERT INTO `student` VALUES ('51', '51');
INSERT INTO `student` VALUES ('52', '52');
INSERT INTO `student` VALUES ('53', '53');
INSERT INTO `student` VALUES ('54', '54');
INSERT INTO `student` VALUES ('55', '55');
INSERT INTO `student` VALUES ('56', '56');
INSERT INTO `student` VALUES ('57', '57');
INSERT INTO `student` VALUES ('58', '58');
INSERT INTO `student` VALUES ('59', '59');
INSERT INTO `student` VALUES ('60', '60');
INSERT INTO `student` VALUES ('61', '61');
INSERT INTO `student` VALUES ('62', '62');
INSERT INTO `student` VALUES ('63', '63');
INSERT INTO `student` VALUES ('64', '64');
INSERT INTO `student` VALUES ('65', '65');
INSERT INTO `student` VALUES ('66', '66');
INSERT INTO `student` VALUES ('67', '67');
INSERT INTO `student` VALUES ('68', '68');
INSERT INTO `student` VALUES ('69', '69');
INSERT INTO `student` VALUES ('70', '70');
INSERT INTO `student` VALUES ('71', '71');
INSERT INTO `student` VALUES ('72', '72');
INSERT INTO `student` VALUES ('73', '73');
INSERT INTO `student` VALUES ('74', '74');
INSERT INTO `student` VALUES ('75', '75');
INSERT INTO `student` VALUES ('76', '76');
INSERT INTO `student` VALUES ('77', '77');
INSERT INTO `student` VALUES ('78', '78');
INSERT INTO `student` VALUES ('79', '79');
INSERT INTO `student` VALUES ('80', '80');
INSERT INTO `student` VALUES ('81', '81');
INSERT INTO `student` VALUES ('82', '82');
INSERT INTO `student` VALUES ('83', '83');
INSERT INTO `student` VALUES ('84', '84');
INSERT INTO `student` VALUES ('85', '85');
INSERT INTO `student` VALUES ('86', '86');
INSERT INTO `student` VALUES ('87', '87');
INSERT INTO `student` VALUES ('88', '88');
INSERT INTO `student` VALUES ('89', '89');
INSERT INTO `student` VALUES ('90', '90');
INSERT INTO `student` VALUES ('91', '91');
INSERT INTO `student` VALUES ('92', '92');
INSERT INTO `student` VALUES ('93', '93');
INSERT INTO `student` VALUES ('94', '94');
INSERT INTO `student` VALUES ('95', '95');
INSERT INTO `student` VALUES ('96', '96');
INSERT INTO `student` VALUES ('97', '97');
INSERT INTO `student` VALUES ('98', '98');
INSERT INTO `student` VALUES ('99', '99');
INSERT INTO `student` VALUES ('100', '100');

-- ----------------------------
-- Table structure for `tbl_activity`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity`;
CREATE TABLE `tbl_activity` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `startDate` char(10) DEFAULT NULL,
  `endDate` char(10) DEFAULT NULL,
  `cost` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_activity
-- ----------------------------
INSERT INTO `tbl_activity` VALUES ('04f1f6b84c9b4a43aebfacae1ca4826c', '40f6cdea0bd34aceb77492a1656d9fb3', '发传单5', '', '', '', '', '2022-05-26 15:43:32', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('627d9f32261a4d1382d2951557ae9c51', '40f6cdea0bd34aceb77492a1656d9fb3', '发传单', '', '', '', '', '2022-05-25 22:04:20', '张三', null, null);

-- ----------------------------
-- Table structure for `tbl_activity_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity_remark`;
CREATE TABLE `tbl_activity_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL COMMENT '0表示未修改，1表示已修改',
  `activityId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_activity_remark
-- ----------------------------
INSERT INTO `tbl_activity_remark` VALUES ('19f135a1f5d24553915eb5b3cf5d8d06', '阿萨监控死角卡数据库', '2022-05-26 15:43:48', '张三', null, null, null, '04f1f6b84c9b4a43aebfacae1ca4826c');

-- ----------------------------
-- Table structure for `tbl_clue`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue`;
CREATE TABLE `tbl_clue` (
  `id` char(32) NOT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `owner` char(32) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue
-- ----------------------------
INSERT INTO `tbl_clue` VALUES ('c1b2fb2ec7994f2ab1a82eb89a8d12e6', '小马云', '', '40f6cdea0bd34aceb77492a1656d9fb3', '阿里巴巴2', '', '', '', '', '', '', '', '张三', '2022-05-26 15:44:12', null, null, '', '', '', '');

-- ----------------------------
-- Table structure for `tbl_clue_activity_relation`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_activity_relation`;
CREATE TABLE `tbl_clue_activity_relation` (
  `id` char(32) NOT NULL,
  `clueId` char(32) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue_activity_relation
-- ----------------------------

-- ----------------------------
-- Table structure for `tbl_clue_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_remark`;
CREATE TABLE `tbl_clue_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `clueId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue_remark
-- ----------------------------

-- ----------------------------
-- Table structure for `tbl_contacts`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts`;
CREATE TABLE `tbl_contacts` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `customerId` char(32) DEFAULT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `birth` char(10) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts
-- ----------------------------
INSERT INTO `tbl_contacts` VALUES ('2d26a2014a634130a72774d705170745', '40f6cdea0bd34aceb77492a1656d9fb3', '', '368c2e83ce884e448aa7ca6e8f719385', '董明珠', '', '', '', '', null, '张三', '2022-05-25 22:41:00', null, null, '', '', '', '');
INSERT INTO `tbl_contacts` VALUES ('3842b43148eb4e6e8436a2651b4283ec', '40f6cdea0bd34aceb77492a1656d9fb3', '', '6cdc609f42f7445fa4423767fd8b8a71', '马云', '', '', '', '', null, '张三', '2022-05-25 22:06:11', null, null, '', '', '', '');

-- ----------------------------
-- Table structure for `tbl_contacts_activity_relation`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_activity_relation`;
CREATE TABLE `tbl_contacts_activity_relation` (
  `id` char(32) NOT NULL,
  `contactsId` char(32) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts_activity_relation
-- ----------------------------
INSERT INTO `tbl_contacts_activity_relation` VALUES ('7941959781514d668ba5820500c24308', 'a5f3c671084a4a9e87bb9fec01e79b19', '627d9f32261a4d1382d2951557ae9c51');

-- ----------------------------
-- Table structure for `tbl_contacts_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_remark`;
CREATE TABLE `tbl_contacts_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `contactsId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts_remark
-- ----------------------------

-- ----------------------------
-- Table structure for `tbl_customer`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer`;
CREATE TABLE `tbl_customer` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_customer
-- ----------------------------
INSERT INTO `tbl_customer` VALUES ('368c2e83ce884e448aa7ca6e8f719385', '40f6cdea0bd34aceb77492a1656d9fb3', '格力公司', '', '', '张三', '2022-05-25 22:41:00', null, null, '', '', '', '');
INSERT INTO `tbl_customer` VALUES ('6cdc609f42f7445fa4423767fd8b8a71', '40f6cdea0bd34aceb77492a1656d9fb3', '阿里巴巴', '', '', '张三', '2022-05-25 22:06:11', null, null, '', '', '', '');

-- ----------------------------
-- Table structure for `tbl_customer_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer_remark`;
CREATE TABLE `tbl_customer_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `customerId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_customer_remark
-- ----------------------------

-- ----------------------------
-- Table structure for `tbl_dic_type`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_type`;
CREATE TABLE `tbl_dic_type` (
  `code` varchar(255) NOT NULL COMMENT '编码是主键，不能为空，不能含有中文。',
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_dic_type
-- ----------------------------
INSERT INTO `tbl_dic_type` VALUES ('appellation', '称呼', '');
INSERT INTO `tbl_dic_type` VALUES ('clueState', '线索状态', '');
INSERT INTO `tbl_dic_type` VALUES ('returnPriority', '回访优先级', '');
INSERT INTO `tbl_dic_type` VALUES ('returnState', '回访状态', '');
INSERT INTO `tbl_dic_type` VALUES ('source', '来源', '');
INSERT INTO `tbl_dic_type` VALUES ('stage', '阶段', '');
INSERT INTO `tbl_dic_type` VALUES ('transactionType', '交易类型', '');

-- ----------------------------
-- Table structure for `tbl_dic_value`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_value`;
CREATE TABLE `tbl_dic_value` (
  `id` char(32) NOT NULL COMMENT '主键，采用UUID',
  `value` varchar(255) DEFAULT NULL COMMENT '不能为空，并且要求同一个字典类型下字典值不能重复，具有唯一性。',
  `text` varchar(255) DEFAULT NULL COMMENT '可以为空',
  `orderNo` varchar(255) DEFAULT NULL COMMENT '可以为空，但不为空的时候，要求必须是正整数',
  `typeCode` varchar(255) DEFAULT NULL COMMENT '外键',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_dic_value
-- ----------------------------
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf10a44eca8511dddfc6896c55', '虚假线索', '虚假线索', '4', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('0fe33840c6d84bf78df55d49b169a894', '销售邮件', '销售邮件', '8', 'source');
INSERT INTO `tbl_dic_value` VALUES ('12302fd42bd349c1bb768b19600e6b20', '交易会', '交易会', '11', 'source');
INSERT INTO `tbl_dic_value` VALUES ('1615f0bb3e604552a86cde9a2ad45bea', '最高', '最高', '2', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('176039d2a90e4b1a81c5ab8707268636', '教授', '教授', '5', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('1e0bd307e6ee425599327447f8387285', '将来联系', '将来联系', '2', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2173663b40b949ce928db92607b5fe57', '丢失线索', '丢失线索', '5', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2876690b7e744333b7f1867102f91153', '未启动', '未启动', '1', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('29805c804dd94974b568cfc9017b2e4c', '07成交', '07成交', '7', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('310e6a49bd8a4962b3f95a1d92eb76f4', '试图联系', '试图联系', '1', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd1', '博士', '博士', '4', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('37ef211719134b009e10b7108194cf46', '01资质审查', '01资质审查', '1', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('391807b5324d4f16bd58c882750ee632', '08丢失的线索', '08丢失的线索', '8', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('3a39605d67da48f2a3ef52e19d243953', '聊天', '聊天', '14', 'source');
INSERT INTO `tbl_dic_value` VALUES ('474ab93e2e114816abf3ffc596b19131', '低', '低', '3', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('48512bfed26145d4a38d3616e2d2cf79', '广告', '广告', '1', 'source');
INSERT INTO `tbl_dic_value` VALUES ('4d03a42898684135809d380597ed3268', '合作伙伴研讨会', '合作伙伴研讨会', '9', 'source');
INSERT INTO `tbl_dic_value` VALUES ('59795c49896947e1ab61b7312bd0597c', '先生', '先生', '1', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('5c6e9e10ca414bd499c07b886f86202a', '高', '高', '1', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('67165c27076e4c8599f42de57850e39c', '夫人', '夫人', '2', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('68a1b1e814d5497a999b8f1298ace62b', '09因竞争丢失关闭', '09因竞争丢失关闭', '9', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('6b86f215e69f4dbd8a2daa22efccf0cf', 'web调研', 'web调研', '13', 'source');
INSERT INTO `tbl_dic_value` VALUES ('72f13af8f5d34134b5b3f42c5d477510', '合作伙伴', '合作伙伴', '6', 'source');
INSERT INTO `tbl_dic_value` VALUES ('7c07db3146794c60bf975749952176df', '未联系', '未联系', '6', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('86c56aca9eef49058145ec20d5466c17', '内部研讨会', '内部研讨会', '10', 'source');
INSERT INTO `tbl_dic_value` VALUES ('9095bda1f9c34f098d5b92fb870eba17', '进行中', '进行中', '3', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('954b410341e7433faa468d3c4f7cf0d2', '已有业务', '已有业务', '1', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('966170ead6fa481284b7d21f90364984', '已联系', '已联系', '3', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('96b03f65dec748caa3f0b6284b19ef2f', '推迟', '推迟', '2', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('97d1128f70294f0aac49e996ced28c8a', '新业务', '新业务', '2', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('9ca96290352c40688de6596596565c12', '完成', '完成', '4', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('9e6d6e15232549af853e22e703f3e015', '需要条件', '需要条件', '7', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('9ff57750fac04f15b10ce1bbb5bb8bab', '02需求分析', '02需求分析', '2', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('a70dc4b4523040c696f4421462be8b2f', '等待某人', '等待某人', '5', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('a83e75ced129421dbf11fab1f05cf8b4', '推销电话', '推销电话', '2', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ab8472aab5de4ae9b388b2f1409441c1', '常规', '常规', '5', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('ab8c2a3dc05f4e3dbc7a0405f721b040', '05提案/报价', '05提案/报价', '5', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('b924d911426f4bc5ae3876038bc7e0ad', 'web下载', 'web下载', '12', 'source');
INSERT INTO `tbl_dic_value` VALUES ('c13ad8f9e2f74d5aa84697bb243be3bb', '03价值建议', '03价值建议', '3', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('c83c0be184bc40708fd7b361b6f36345', '最低', '最低', '4', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('db867ea866bc44678ac20c8a4a8bfefb', '员工介绍', '员工介绍', '3', 'source');
INSERT INTO `tbl_dic_value` VALUES ('e44be1d99158476e8e44778ed36f4355', '04确定决策者', '04确定决策者', '4', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('e5f383d2622b4fc0959f4fe131dafc80', '女士', '女士', '3', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('e81577d9458f4e4192a44650a3a3692b', '06谈判/复审', '06谈判/复审', '6', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('fb65d7fdb9c6483db02713e6bc05dd19', '在线商场', '在线商场', '5', 'source');
INSERT INTO `tbl_dic_value` VALUES ('fd677cc3b5d047d994e16f6ece4d3d45', '公开媒介', '公开媒介', '7', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ff802a03ccea4ded8731427055681d48', '外部介绍', '外部介绍', '4', 'source');

-- ----------------------------
-- Table structure for `tbl_tran`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran`;
CREATE TABLE `tbl_tran` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `expectedDate` char(10) DEFAULT NULL,
  `customerId` char(32) DEFAULT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `activityId` char(32) DEFAULT NULL,
  `contactsId` char(32) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contactSummary` varchar(255) DEFAULT NULL,
  `nextContactTime` char(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran
-- ----------------------------
INSERT INTO `tbl_tran` VALUES ('b4cb9953eb9e4399af0800b7e2f8f399', '40f6cdea0bd34aceb77492a1656d9fb3', '500', '代言', '2022-05-26', '6cdc609f42f7445fa4423767fd8b8a71', '04确定决策者', null, '', '627d9f32261a4d1382d2951557ae9c51', '3842b43148eb4e6e8436a2651b4283ec', '张三', '2022-05-25 22:06:11', '张三', '2022-05-26 15:43:17', '', '', '');

-- ----------------------------
-- Table structure for `tbl_tran_history`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_history`;
CREATE TABLE `tbl_tran_history` (
  `id` char(32) NOT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `expectedDate` char(10) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `tranId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran_history
-- ----------------------------
INSERT INTO `tbl_tran_history` VALUES ('0351d5ba4a874578ab38bba1548e6636', '04确定决策者', '500', '2022-05-26', '2022-05-26 15:43:17', '张三', 'b4cb9953eb9e4399af0800b7e2f8f399');
INSERT INTO `tbl_tran_history` VALUES ('17a5ef129088423c922e09bac3288097', '04确定决策者', '500', '2022-05-26', '2022-05-25 22:06:11', '张三', 'b4cb9953eb9e4399af0800b7e2f8f399');
INSERT INTO `tbl_tran_history` VALUES ('2bccdf6393a543fdba63c02e18b14c3a', '05提案/报价', '500', '2022-05-26', '2022-05-26 13:36:25', '张三', 'b4cb9953eb9e4399af0800b7e2f8f399');
INSERT INTO `tbl_tran_history` VALUES ('3c5746f2bfc744b88f4f8be779da4730', '07成交', '500', '2022-05-26', '2022-05-25 22:07:48', '张三', 'b4cb9953eb9e4399af0800b7e2f8f399');
INSERT INTO `tbl_tran_history` VALUES ('424635f799014186aca8a14447856081', '08丢失的线索', '500', '2022-05-26', '2022-05-26 15:43:16', '张三', 'b4cb9953eb9e4399af0800b7e2f8f399');
INSERT INTO `tbl_tran_history` VALUES ('4f6d886e73134adf9ec53aa05139fac6', '06谈判/复审', '500', '2022-05-26', '2022-05-25 22:07:47', '张三', 'b4cb9953eb9e4399af0800b7e2f8f399');
INSERT INTO `tbl_tran_history` VALUES ('6a45348c7c4f4f83a858ae7f68d2aaf4', '08丢失的线索', '500', '2022-05-26', '2022-05-26 13:30:50', '张三', 'b4cb9953eb9e4399af0800b7e2f8f399');
INSERT INTO `tbl_tran_history` VALUES ('7ae31d506f2d4630af744c29a69ffdbd', '04确定决策者', '500', '2022-05-26', '2022-05-26 15:43:15', '张三', 'b4cb9953eb9e4399af0800b7e2f8f399');
INSERT INTO `tbl_tran_history` VALUES ('8d1b204830174778bd0a6ce62053d78f', '06谈判/复审', '500', '2022-05-26', '2022-05-26 15:43:14', '张三', 'b4cb9953eb9e4399af0800b7e2f8f399');
INSERT INTO `tbl_tran_history` VALUES ('b4855600fc194f4cbd818a41e64c765f', '08丢失的线索', '500', '2022-05-26', '2022-05-25 22:07:45', '张三', 'b4cb9953eb9e4399af0800b7e2f8f399');
INSERT INTO `tbl_tran_history` VALUES ('dd4b20b2042c4795916b502e5208d0ac', '07成交', '500', '2022-05-26', '2022-05-25 22:07:44', '张三', 'b4cb9953eb9e4399af0800b7e2f8f399');

-- ----------------------------
-- Table structure for `tbl_tran_remark`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_remark`;
CREATE TABLE `tbl_tran_remark` (
  `id` char(32) NOT NULL,
  `noteContent` varchar(255) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editFlag` char(1) DEFAULT NULL,
  `tranId` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran_remark
-- ----------------------------

-- ----------------------------
-- Table structure for `tbl_user`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE `tbl_user` (
  `id` char(32) NOT NULL COMMENT 'uuid\r\n            ',
  `loginAct` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `loginPwd` varchar(255) DEFAULT NULL COMMENT '密码不能采用明文存储，采用密文，MD5加密之后的数据',
  `email` varchar(255) DEFAULT NULL,
  `expireTime` char(19) DEFAULT NULL COMMENT '失效时间为空的时候表示永不失效，失效时间为2018-10-10 10:10:10，则表示在该时间之前该账户可用。',
  `lockState` char(1) DEFAULT NULL COMMENT '锁定状态为空时表示启用，为0时表示锁定，为1时表示启用。',
  `deptno` char(4) DEFAULT NULL,
  `allowIps` varchar(255) DEFAULT NULL COMMENT '允许访问的IP为空时表示IP地址永不受限，允许访问的IP可以是一个，也可以是多个，当多个IP地址的时候，采用半角逗号分隔。允许IP是192.168.100.2，表示该用户只能在IP地址为192.168.100.2的机器上使用。',
  `createTime` char(19) DEFAULT NULL,
  `createBy` varchar(255) DEFAULT NULL,
  `editTime` char(19) DEFAULT NULL,
  `editBy` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_user
-- ----------------------------
INSERT INTO `tbl_user` VALUES ('06f5fc056eac41558a964f96daa7f27c', 'ls', '李四', '202cb962ac59075b964b07152d234b70', 'ls@163.com', '2022-07-22 21:50:05', '1', 'A001', '0:0:0:0:0:0:0:1', '2018-11-22 12:11:40', '李四', null, null);
INSERT INTO `tbl_user` VALUES ('40f6cdea0bd34aceb77492a1656d9fb3', 'zs', '张三', '202cb962ac59075b964b07152d234b70', 'zs@qq.com', '2022-07-28 23:50:55', '1', 'A001', '192.168.1.1,192.168.1.2,127.0.0.1,0:0:0:0:0:0:0:1', '2021-01-22 11:37:34', '张三', null, null);
