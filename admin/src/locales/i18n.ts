import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

const resources = {
  en: {
    translation: {
      'app.title': 'APSCVIR Conference Management',
      'menu.dashboard': 'Dashboard',
      'menu.events': 'Events',
      'menu.sessions': 'Sessions',
      'menu.speakers': 'Speakers',
      'menu.users': 'Users',
      'menu.materials': 'Materials',
      'menu.checkin': 'Check-in',
      'login.title': 'Admin Login',
      'login.email': 'Email',
      'login.password': 'Password',
      'login.submit': 'Sign In',
      'common.create': 'Create',
      'common.edit': 'Edit',
      'common.delete': 'Delete',
      'common.save': 'Save',
      'common.cancel': 'Cancel',
      'common.search': 'Search',
      'common.actions': 'Actions',
      'common.status': 'Status',
      'common.logout': 'Logout',
      'dashboard.totalEvents': 'Total Events',
      'dashboard.totalUsers': 'Total Users',
      'dashboard.activeUsers': 'Active Users',
      'dashboard.publishedEvents': 'Published Events',
    },
  },
  zh: {
    translation: {
      'app.title': 'APSCVIR 会议管理系统',
      'menu.dashboard': '仪表盘',
      'menu.events': '会议管理',
      'menu.sessions': '议程管理',
      'menu.speakers': '嘉宾管理',
      'menu.users': '用户管理',
      'menu.materials': '资料管理',
      'menu.checkin': '签到管理',
      'login.title': '管理后台登录',
      'login.email': '邮箱',
      'login.password': '密码',
      'login.submit': '登录',
      'common.create': '新建',
      'common.edit': '编辑',
      'common.delete': '删除',
      'common.save': '保存',
      'common.cancel': '取消',
      'common.search': '搜索',
      'common.actions': '操作',
      'common.status': '状态',
      'common.logout': '退出登录',
      'dashboard.totalEvents': '会议总数',
      'dashboard.totalUsers': '用户总数',
      'dashboard.activeUsers': '活跃用户',
      'dashboard.publishedEvents': '已发布会议',
    },
  },
};

i18n.use(initReactI18next).init({
  resources,
  lng: localStorage.getItem('admin_lang') || 'zh',
  fallbackLng: 'en',
  interpolation: { escapeValue: false },
});

export default i18n;
