<script setup>
import { ref } from "vue";
import { VNodeRenderer } from "@layouts/components/VNodeRenderer";
import { themeConfig } from "@themeConfig";
import authV2RegisterIllustrationBorderedDark from "@images/pages/auth-v2-register-illustration-bordered-dark.png";
import authV2RegisterIllustrationBorderedLight from "@images/pages/auth-v2-register-illustration-bordered-light.png";
import authV2RegisterIllustrationDark from "@images/pages/auth-v2-register-illustration-dark.png";
import authV2RegisterIllustrationLight from "@images/pages/auth-v2-register-illustration-light.png";
import authV2RegisterMaskDark from "@images/pages/auth-v2-register-mask-dark.png";
import authV2RegisterMaskLight from "@images/pages/auth-v2-register-mask-light.png";
import { useRouter } from "vue-router";


const authThemeMask = useGenerateImageVariant(
  authV2RegisterMaskLight,
  authV2RegisterMaskDark
);
const authThemeImg = useGenerateImageVariant(
  authV2RegisterIllustrationLight,
  authV2RegisterIllustrationDark,
  authV2RegisterIllustrationBorderedLight,
  authV2RegisterIllustrationBorderedDark,
  true
);


definePage({
  meta: {
    layout: "blank",
    unauthenticatedOnly: false,
  },
});

const router = useRouter()

const form = ref({
  nome: "",
  username: "",
  email: "",
  password: "",
  roles: ["user"], 
});


const snackbarMessage = ref("");
const snackbarColor = ref("success");
const snackbar = ref(false);

const cadastrarUtilizador = async () => {
  try {
    const userData = {
      nome: form.value.nome,
      username: form.value.username,
      email: form.value.email,
      password: form.value.password,
      roles: ["user"], 
    };

    // Chamada API para registrar o utilizador
    const response = await $api("/autenticacao/cadastro", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(userData),
    });

   
    if (response.message === "Utilizador Registado com sucesso!") {
      snackbarMessage.value = "Cadastrado bem sucedido";
      snackbarColor.value = "success";
      router.push("/login")
    } else if (response.status === 400) {
      if (response.message  === "Error: Email existente!") {
        snackbarMessage.value = "O e-mail já está em uso!";
      } else if (response.message  === "Error: Username existente!") {
        snackbarMessage.value = "O username já está em uso!";
      } else {
        snackbarMessage.value = "Erro ao criar o utilizador!";
      }
      snackbarColor.value = "error";
    } else {
      snackbarMessage.value = "Erro ao criar o utilizador!";
      snackbarColor.value = "error";
    }
  } catch (error) {
    snackbarMessage.value = "Erro de conexão com o servidor!";
    snackbarColor.value = "error";
  }
  snackbar.value = true; 
};


const isPasswordVisible = ref(false);
</script>

<template>
  <RouterLink to="/">
    <div class="app-logo auth-logo">
      <VNodeRenderer :nodes="themeConfig.app.logo" />
      <h1 class="app-logo-title">
        {{ themeConfig.app.title }}
      </h1>
    </div>
  </RouterLink>

  <VRow no-gutters class="auth-wrapper">
    <VCol
      md="8"
      class="d-none d-md-flex align-center justify-center position-relative"
    >
      <div class="d-flex align-center justify-center pa-10">
        <img
          :src="authThemeImg"
          class="auth-illustration w-100"
          alt="auth-illustration"
        />
      </div>
      <VImg
        :src="authThemeMask"
        class="d-none d-md-flex auth-footer-mask"
        alt="auth-mask"
      />
    </VCol>

    <VCol
      cols="12"
      md="4"
      class="auth-card-v2 d-flex align-center justify-center"
      style="background-color: rgb(var(--v-theme-surface));"
    >
      <VCard flat :max-width="500" class="mt-12 mt-sm-0 pa-5 pa-lg-7">
        <VCardText>
          <h2 class="mb-4 text-h3 font-weight-bold">
            Criar conta
          </h2>
          <p class="mb-3 text-body-2">
            Crie uma nova conta para iniciar sessão ou recuperar a sua senha.
          </p>
        </VCardText>

        <VCardText>
          <VForm @submit.prevent="cadastrarUtilizador">
            <VRow>
              
              <VCol cols="12">
                <VTextField
                  v-model="form.nome"
                  autofocus
                  label="Nome Completo"
                  placeholder="Nome Completo..."
                />
              </VCol>

            
              <VCol cols="12">
                <VTextField
                  v-model="form.username"
                  label="Username"
                  placeholder="username"
                />
              </VCol>

             
              <VCol cols="12">
                <VTextField
                  v-model="form.email"
                  label="E-mail"
                  type="email"
                  placeholder="exemplo@email.com"
                />
              </VCol>

              
              <VCol cols="12">
                <VTextField
                  v-model="form.password"
                  label="Senha"
                  placeholder="············"
                  :type="isPasswordVisible ? 'text' : 'password'"
                  :append-inner-icon="
                    isPasswordVisible ? 'ri-eye-off-line' : 'ri-eye-line'
                  "
                  @click:append-inner="isPasswordVisible = !isPasswordVisible"
                />
              </VCol>

              
              <VCol cols="12">
                <VCheckbox
                  v-model="form.privacyPolicies"
                  label="Aceito as políticas de privacidade & termos"
                />
              </VCol>

             
              <VCol cols="12">
                <VBtn block type="submit">Cadastrar</VBtn>
              </VCol>
            </VRow>
          </VForm>
          <VCol cols="12" class="text-body-1 text-center">
                <RouterLink
                  to="login"
                  class="text-primary ms-1 d-inline-block text-body-1"
                >
                  Fazer login em vez disso
                </RouterLink>
              </VCol>
    
          <VSnackbar v-model="snackbar" :color="snackbarColor">
            {{ snackbarMessage }}
          </VSnackbar>
        </VCardText>
      </VCard>
    </VCol>
  </VRow>
</template>

<style lang="scss">
@use "@core/scss/template/pages/page-auth.scss";
</style>
