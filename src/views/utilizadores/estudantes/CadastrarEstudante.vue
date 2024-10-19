<script setup>
import { PerfectScrollbar } from "vue3-perfect-scrollbar";
import { ref, nextTick } from "vue";
import { VAutocomplete } from "vuetify/components";


const token = useCookie("accessToken").value;

const distritos = ref([]);
const selectedDistrito = ref(null); 

const props = defineProps({
  isDrawerOpen: {
    type: Boolean,
    required: true,
  },
});

const emit = defineEmits(["update:isDrawerOpen", "userData"]);

const isFormValid = ref(false);
const refForm = ref();
const nomeCompleto = ref("");
const dataNascimento = ref(null);
const sexo = ref("");
const bilheteIdentificacao = ref("");
const religiao = ref("");
const grupoSanguineo = ref("");
const endereco = ref("");

const escolaAnterior = ref("");
const nomeDoPai = ref("");
const nomeDaMae = ref("");
const numeroTelefonePrincipal = ref("");

// Arrays de opções conhecidas
const opcoesSexo = ["M", "F"];
const opcoesReligiao = ["Cristã", "Muçulmana", "Hindu", "Outra"];
const opcoesGrupoSanguineo = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

// Snackbar para exibir mensagens de sucesso ou erro
const snackbarMessage = ref("");
const snackbarColor = ref("success");
const snackbar = ref(false);

// 👉 drawer close
const closeNavigationDrawer = () => {
  emit("update:isDrawerOpen", false);
  nextTick(() => {
    refForm.value?.reset();
    refForm.value?.resetValidation();
  });
};

// Função para cadastrar o estudante na API
const registerStudent = async (studentData) => {
  try {
    const response = await $api("/alunos/cadastrar", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(studentData),
    });

    return response; // Retornar a resposta da API

  } catch (error) {
    console.error("Erro ao cadastrar estudante:", error);
    throw new Error("Erro ao cadastrar estudante"); // Lançar erro para ser tratado na submissão
  }
};

// Função de submissão do formulário
const onSubmit = async () => {
  refForm.value?.validate().then(async ({ valid }) => {
    if (valid) {
      const studentData = {
        nomeCompleto: nomeCompleto.value,
        dataNascimento: dataNascimento.value,
        distritoNascimento: selectedDistrito.value, 
        sexo: sexo.value,
        bilheteIdentificacao: bilheteIdentificacao.value,
        religiao: religiao.value,
        grupoSanguineo: grupoSanguineo.value,
        endereco: endereco.value,
        escolaAnterior: escolaAnterior.value,
        nomeDoPai: nomeDoPai.value,
        nomeDaMae: nomeDaMae.value,
        numeroTelefonePrincipal: numeroTelefonePrincipal.value,
      };

      try {
        await registerStudent(studentData); // Chamada para cadastrar estudante
        snackbarMessage.value = "Estudante cadastrado com sucesso!";
        snackbarColor.value = "success";
        snackbar.value = true;
      } catch (error) {
        snackbarMessage.value = "Erro ao cadastrar estudante. Tente novamente.";
        snackbarColor.value = "error";
        snackbar.value = true;
      } finally {
        emit("update:isDrawerOpen", false);
        nextTick(() => {
          refForm.value?.reset();
          refForm.value?.resetValidation();
        });
      }
    } else {
      // Exibir mensagem de erro se a validação falhar
      snackbarMessage.value = "Por favor, preencha todos os campos obrigatórios corretamente.";
      snackbarColor.value = "error";
      snackbar.value = true;
    }
  });
};

// Função para atualizar o valor do drawer
const handleDrawerModelValueUpdate = (val) => {
  emit("update:isDrawerOpen", val);
};

const buscarDistritos = async () => {
  try {
    const res = await $api("/distritos", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    distritos.value = res.map((distrito) => ({
      id: distrito.id,
      nome: distrito.nome,
      provincia: distrito.provincia,
    }));

    distritos.value = distritos.value.map((distrito) => ({
      title: distrito.nome,
      value: distrito.nome,
    }));
  } catch (err) {
    console.error("Erro ao buscar distritos:", err);
    snackbarMessage.value = "Erro ao buscar distritos. Tente novamente mais tarde.";
    snackbarColor.value = "error";
    snackbar.value = true;
  }
};

buscarDistritos();
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
      title="Cadastrar Aluno"
      @cancel="closeNavigationDrawer"
    />

    <VDivider />

    <PerfectScrollbar :options="{ wheelPropagation: false }">
      <VCard flat>
        <VCardText>
          <!-- 👉 Form -->
          <VForm ref="refForm" v-model="isFormValid" @submit.prevent="onSubmit">
            <VRow>
              <!-- Nome Completo -->
              <VCol cols="12">
                <VTextField
                  v-model="nomeCompleto"
                  label="Nome Completo"
                  placeholder="Nome Completo"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <!-- Data de Nascimento -->
              <VCol cols="12">
                <VTextField
                  v-model="dataNascimento"
                  label="Data de Nascimento"
                  type="date"
                  :rules="[requiredValidator]"
                  placeholder="Selecione a data"
                />
              </VCol>

              <!-- Distrito de Nascimento -->
              <VCol cols="12">
                <VAutocomplete
                  v-model="selectedDistrito"
                  label="Distrito de Nascimento"
                  placeholder="Selecionar Distrito de Nascimento"
                  :items="distritos"
                  clearable
                  clear-icon="ri-close-line"
                />
              </VCol>

              <!-- Sexo como Select -->
              <VCol cols="12">
                <VSelect
                  v-model="sexo"
                  :items="opcoesSexo"
                  label="Sexo"
                  placeholder="Selecione o sexo"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <!-- Bilhete de Identificação -->
              <VCol cols="12">
                <VTextField
                  v-model="bilheteIdentificacao"
                  label="Bilhete de Identificação"
                  placeholder="Número do Bilhete"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <!-- Religião como Select -->
              <VCol cols="12">
                <VAutocomplete
                  v-model="religiao"
                  :items="opcoesReligiao"
                  label="Religião"
                  placeholder="Selecione a religião"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <!-- Grupo Sanguíneo como Select -->
              <VCol cols="12">
                <VAutocomplete
                  v-model="grupoSanguineo"
                  :items="opcoesGrupoSanguineo"
                  label="Grupo Sanguíneo"
                  placeholder="Selecione o grupo sanguíneo"
                />
              </VCol>

              <!-- Endereço -->
              <VCol cols="12">
                <VTextField
                  v-model="endereco"
                  label="Endereço"
                  placeholder="Endereço"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <!-- Escola Anterior -->
              <VCol cols="12">
                <VTextField
                  v-model="escolaAnterior"
                  label="Escola Anterior"
                  placeholder="Escola Anterior"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <!-- Nome do Pai -->
              <VCol cols="12">
                <VTextField
                  v-model="nomeDoPai"
                  label="Nome do Pai"
                  placeholder="Nome do Pai"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <!-- Nome da Mãe -->
              <VCol cols="12">
                <VTextField
                  v-model="nomeDaMae"
                  label="Nome da Mãe"
                  placeholder="Nome da Mãe"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <!-- Número de Telefone Principal -->
              <VCol cols="12">
                <VTextField
                  v-model="numeroTelefonePrincipal"
                  label="Número de Telefone Principal"
                  placeholder="Telefone"
                  :rules="[requiredValidator, integerValidator]"
                />
              </VCol>

              <!-- Submit and Cancel -->
              <VCol cols="12">
                <VBtn type="submit" class="me-4">Cadastrar</VBtn>
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
      </VCard>
    </PerfectScrollbar>

    <!-- Snackbar para mensagens de sucesso ou erro -->
    <VSnackbar v-model="snackbar" :color="snackbarColor" timeout="4000">
      {{ snackbarMessage }}
    </VSnackbar>
  </VNavigationDrawer>
</template>
