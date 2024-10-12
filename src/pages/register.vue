<script setup>
import { ref } from "vue";
import { VNodeRenderer } from "@layouts/components/VNodeRenderer";
import { themeConfig } from "@themeConfig";
import AuthProvider from "@/views/pages/authentication/AuthProvider.vue";
import authV2RegisterIllustrationBorderedDark from "@images/pages/auth-v2-register-illustration-bordered-dark.png";
import authV2RegisterIllustrationBorderedLight from "@images/pages/auth-v2-register-illustration-bordered-light.png";
import authV2RegisterIllustrationDark from "@images/pages/auth-v2-register-illustration-dark.png";
import authV2RegisterIllustrationLight from "@images/pages/auth-v2-register-illustration-light.png";
import authV2RegisterMaskDark from "@images/pages/auth-v2-register-mask-dark.png";
import authV2RegisterMaskLight from "@images/pages/auth-v2-register-mask-light.png";

// Definir imagens temáticas
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

// Configuração da página sem autenticação
definePage({
  meta: {
    layout: "blank",
    unauthenticatedOnly: false,
  },
});

// Estados do formulário e de erro
const form = ref({
  nome: "",
  username: "",
  email: "",
  password: "",
  roles: ["user"], // Role definida como 'user'
});

// Estado do snackbar para exibição de feedback
const snackbarMessage = ref("");
const snackbarColor = ref("success");
const snackbar = ref(false);

// Função de cadastro de utilizador
const cadastrarUtilizador = async () => {
  try {
    const userData = {
      nome: form.value.nome,
      username: form.value.username,
      email: form.value.email,
      password: form.value.password,
      roles: ["user"], // Role definida no momento do cadastro
    };

    // Chamada API para registrar o utilizador
    const response = await $api("/cadastro", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(userData),
    });

    // Verificar status da resposta
    if (response.status === 200) {
      snackbarMessage.value = "Utilizador cadastrado com sucesso!";
      snackbarColor.value = "success";
    } else if (response.status === 400) {
      const errorData = await response.json();
      if (errorData.message === "Error: Email existente!") {
        snackbarMessage.value = "O e-mail já está em uso!";
      } else if (errorData.message === "Error: Username existente!") {
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
  snackbar.value = true; // Mostrar snackbar
};

// Controle de visibilidade da senha
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
          <h4 class="text-h4 mb-1">Adventure starts here 🚀</h4>
          <p class="mb-0">Make your app management easy and fun!</p>
        </VCardText>

        <VCardText>
          <VForm @submit.prevent="cadastrarUtilizador">
            <VRow>
              <!-- Nome -->
              <VCol cols="12">
                <VTextField
                  v-model="form.nome"
                  autofocus
                  label="Nome"
                  placeholder="Nome Completo..."
                />
              </VCol>

              <!-- Username -->
              <VCol cols="12">
                <VTextField
                  v-model="form.username"
                  label="Username"
                  placeholder="username"
                />
              </VCol>

              <!-- Email -->
              <VCol cols="12">
                <VTextField
                  v-model="form.email"
                  label="Email"
                  type="email"
                  placeholder="exemplo@email.com"
                />
              </VCol>

              <!-- Password -->
              <VCol cols="12">
                <VTextField
                  v-model="form.password"
                  label="Password"
                  placeholder="············"
                  :type="isPasswordVisible ? 'text' : 'password'"
                  :append-inner-icon="
                    isPasswordVisible ? 'ri-eye-off-line' : 'ri-eye-line'
                  "
                  @click:append-inner="isPasswordVisible = !isPasswordVisible"
                />
              </VCol>

              <!-- Aceitar políticas de privacidade -->
              <VCol cols="12">
                <VCheckbox
                  v-model="form.privacyPolicies"
                  label="Aceito as políticas de privacidade & termos"
                />
              </VCol>

              <!-- Botão de Cadastro -->
              <VCol cols="12">
                <VBtn block type="submit">Cadastrar</VBtn>
              </VCol>
            </VRow>
          </VForm>

          <!-- Snackbar para feedback do utilizador -->
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
