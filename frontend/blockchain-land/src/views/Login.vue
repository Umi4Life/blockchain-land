<template>
  <v-content>
    <v-container
            class="fill-height"
            fluid
    >
      <v-row
              align="center"
              justify="center"
      >
        <v-col
                cols="12"
                sm="8"
                md="4"
        >
          <v-card class="elevation-12">
            <v-toolbar
                    color="primary"
                    dark
                    flat
            >
              <v-toolbar-title>Login form</v-toolbar-title>
              <v-spacer />
            </v-toolbar>
            <v-card-text>
              <v-form>
                <v-text-field
                        label="Email"
                        name="email"
                        type="email"
                        v-model="email"
                />

                <v-text-field
                        id="password"
                        label="Password"
                        name="password"
                        type="password"
                        v-model="password"
                />
              </v-form>
            </v-card-text>
            <v-card-actions>
              <v-spacer />
              <v-btn color="primary" @click="login(email, password)">Login</v-btn>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </v-content>
</template>

<script>
import firebase from 'firebase'
import router from '../router/index'
import store from '../store/index'
export default {
  name: 'login',
  props: {
      source: String,
  },

  data: () => ({
      email:'company@company.com',
      password:'111111',
  }),
  methods: {
      login: function (email, password){
          store.commit('setLoading', true);
          firebase.auth().setPersistence(firebase.auth.Auth.Persistence.LOCAL)
              .then(function(){
                  return firebase.auth().signInWithEmailAndPassword(email, password)
                      .then(function(user){
                              const ref = firebase.database().ref('users/' + user.user.uid)
                              store.commit('setUid', user.user.uid);
                              ref.on('value', function (snapshot) {
                                  if(snapshot.val()['userType'] === 'company') router.replace('home')
                                  store.commit('setLoading', false);
                              });


                          },
                          function(err){
                              alert(err.message)
                          }
                      )
              })

      }
  }
};
</script>
