import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify';
import router from './router'
import firebase from 'firebase';


Vue.config.productionTip = false

// Your web app's Firebase configuration
var firebaseConfig = {
    apiKey: "AIzaSyBq2HJISyJ4pSMRPoMPCE-JNkKly0kgTZ8",
    authDomain: "blockchain-land.firebaseapp.com",
    databaseURL: "https://blockchain-land.firebaseio.com",
    projectId: "blockchain-land",
    storageBucket: "blockchain-land.appspot.com",
    messagingSenderId: "89271096162",
    appId: "1:89271096162:web:187f00679eaa4a1d7e923b",
    measurementId: "G-GRGKW1ZZCT"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);

new Vue({
  vuetify,
  router,
  render: h => h(App)
}).$mount('#app')
