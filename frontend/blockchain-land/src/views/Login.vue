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
              <v-btn color="primary" @click="login">Login</v-btn>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </v-content>
</template>

<script>
import firebase from 'firebase'
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
      login: function (){
          firebase.auth().signInWithEmailAndPassword(this.email, this.password).then(
              function(user){
                  let val = null;
                  let ref = firebase.database().ref("users/"+user.user.uid+"/userType");
                  ref.on("value", function(snapshot) {
                      val = snapshot.val();
                      alert(user.user.uid + '\n' + val)
                  }, function (errorObject) {
                      alert(errorObject.code);
                  });

                  // alert(user.user.uid + '\n' + val)
              },
              function(err){
                alert(err.message)
              }
          )
      }
  }
};
</script>
