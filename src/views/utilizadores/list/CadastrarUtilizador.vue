<script setup>
import { PerfectScrollbar } from "vue3-perfect-scrollbar";
import { ref, nextTick } from "vue"; // Importação do nextTick
import { useRouter } from "vue-router"; // Para redirecionar após o cadastro

const props = defineProps({
  isDrawerOpen: {
    type: Boolean,
    required: true,
  },
});

const emit = defineEmits(["update:isDrawerOpen", "userData"]);

const isFormValid = ref(false);
const refForm = ref();
const userName = ref("");
const nome = ref("");
const email = ref("");
const password = ref("");
const roles = ref([]); // Definição do ref para roles
const snackbarMessage = ref("");
const snackbarColor = ref("success");
const snackbar = ref(false); // Para controlar a exibição do snackbar

const rolesList = [
  "user",
  "admin",
  "estudante",
  "professor",
  "encarregado",
  "pedagogico",
];

// 👉 drawer close
const closeNavigationDrawer = () => {
  emit("update:isDrawerOpen", false);
  nextTick(() => {
    refForm.value?.reset();
    refForm.value?.resetValidation();
  });
};

const onSubmit = async () => {
  refForm.value?.validate().then(async ({ valid }) => {
    if (valid) {
      const userData = {
        nome: nome.value,
        username: userName.value,
        email: email.value,
        password: password.value,
        roles: roles.value, // Envio das roles
      };

      try {
        // Chamada API para cadastrar o utilizador
        const response = await $api("/autenticacao/cadastro", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(userData),
        });

        // Verificação da resposta da API
        if (response.message === "Utilizador Registado com sucesso!") {
          snackbarMessage.value = "Utilizador cadastrado com sucesso!";
          snackbarColor.value = "success";
          closeNavigationDrawer(); // Fecha o drawer após o sucesso
        } else {
          throw new Error(response.message || "Erro ao criar o utilizador.");
        }
      } catch (error) {
        snackbarMessage.value = error.message || "Erro de conexão com o servidor!";
        snackbarColor.value = "error";
      }
      snackbar.value = true; // Exibe o snackbar
    }
  });
};

const handleDrawerModelValueUpdate = (val) => {
  emit("update:isDrawerOpen", val);
};
</script>

<template>
  <VNavigationDrawer
    temporary
    :width="400"
    location="end"
    class="scrollable-content"
    :model-value="props.isDrawerOpen"
    @update:model-value="handleDrawerModelValueUpdate"
  >
    <!-- 👉 Title -->
    <AppDrawerHeaderSection
      title="Cadastrar Utilizador"
      @cancel="closeNavigationDrawer"
    />

    <VDivider />

    <PerfectScrollbar :options="{ wheelPropagation: false }">
      <VCard flat>
        <VCardText>
          <!-- 👉 Form -->
          <VForm ref="refForm" v-model="isFormValid" @submit.prevent="onSubmit">
            <VRow>
              <VCol cols="12">
                <VTextField
                  v-model="nome"
                  :rules="[requiredValidator]"
                  label="Nome"
                  placeholder="Nome Completo"
                />
              </VCol>

              <!-- 👉 Email -->
              <VCol cols="12">
                <VTextField
                  v-model="email"
                  :rules="[requiredValidator, emailValidator]"
                  label="Email"
                  placeholder="exemplo@email.com"
                />
              </VCol>

              <VCol cols="12">
                <VTextField
                  v-model="userName"
                  :rules="[requiredValidator]"
                  label="Username"
                  placeholder="username"
                />
              </VCol>
              <!-- 👉 Password -->
              <VCol cols="12">
                <VTextField
                  v-model="password"
                  :rules="[requiredValidator]"
                  label="Password"
                  placeholder="****************"
                  type="password" 
                />
              </VCol>
              <!-- 👉 Roles -->
              <VCol cols="12">
                <VSelect
                  v-model="roles"
                  :items="rolesList"
                  multiple
                  label="Roles"
                />
              </VCol>

              <!-- 👉 Submit and Cancel -->
              <VCol cols="12">
                <VBtn type="submit" class="me-4"> Cadastrar </VBtn>
                <VBtn
                  type="reset"
                  variant="outlined"
                  color="error"
                  @click="closeNavigationDrawer"
                >
                  Cancelar
                </VBtn>
              </VCol>
            </VRow>
          </VForm>
        </VCardText>
        <VSnackbar v-model="snackbar" :color="snackbarColor">
          {{ snackbarMessage }}
        </VSnackbar>
      </VCard>
    </PerfectScrollbar>
  </VNavigationDrawer>
</template>

<style lang="scss">
/* Adicione estilos se necessário */
</style>
