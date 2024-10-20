<script setup>
import { nextTick, ref } from "vue";
import { PerfectScrollbar } from "vue3-perfect-scrollbar";
import { VAutocomplete } from "vuetify/components";

const distritos = ref([]);
const areas_cientificas = ref([]);
const selectedDistrito = ref(null);
const selectedArea = ref(null);

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
const estadoCivil = ref("");
const areaFormacao = ref("");
const escolaAnterior = ref("Essa e a primeira Escola");
const nomeDoPai = ref("");
const nomeDaMae = ref("");
const numeroTelefonePrincipal = ref("");
const numeroTelefoneAlternativo = ref("");
const email = ref("");

const opcoesSexo = ["Masculino", "Feminino"];
const opcoesReligiao = [
  "Cristã",
  "Católica",
  "Evangélica",
  "Adventista",
  "Protestante",
  "Ortodoxa",
  "Muçulmana",
  "Sunita",
  "Xiita",
  "Hindu",
  "Budista",
  "Judaica",
  "Espírita",
  "Mórmon",
  "Testemunhas de Jeová",
  "Ateu",
  "Agnóstico",
  "Outra",
];

const opcoesGrupoSanguineo = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
const opcoesEstadoCivil = [
  "Casado",
  "Solteiro",
  "Viúvo",
  "Divorciado",
  "Separado",
  "União de Facto",
  "Desquitado",
  "Outro",
];


const snackbarMessage = ref("");
const snackbarColor = ref("success");
const snackbar = ref(false);


const closeNavigationDrawer = () => {
  emit("update:isDrawerOpen", false);
  nextTick(() => {
    refForm.value?.reset();
    refForm.value?.resetValidation();
  });
};


const registerProfessor = async (professorData) => {
  try {
    const response = await $api("/professores/cadastrar", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(professorData),
    });

    return response;
  } catch (error) {
    console.error("Erro ao cadastrar professor:", error);
    throw new Error("Erro ao cadastrar professor");
  }
};

const onSubmit = async () => {
  refForm.value?.validate().then(async ({ valid }) => {
    if (valid) {
      const professorData = {
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
        estadoCivil: estadoCivil.value,
        areaFormacao: selectedArea.value,
        numeroTelefonePrincipal: numeroTelefonePrincipal.value,
        numeroTelefoneAlternativo: numeroTelefoneAlternativo.value,
        email: email.value,
      };

      try {
        await registerProfessor(professorData);
        snackbarMessage.value = "Professor cadastrado com sucesso!";
        snackbarColor.value = "success";
        snackbar.value = true;
      } catch (error) {
        snackbarMessage.value = "Erro ao cadastrar professor. Tente novamente.";
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
      snackbarMessage.value =
        "Por favor, preencha todos os campos obrigatórios corretamente.";
      snackbarColor.value = "error";
      snackbar.value = true;
    }
  });
};

const handleDrawerModelValueUpdate = (val) => {
  emit("update:isDrawerOpen", val);
};

const buscarAreas = async () => {
  try {
    const res = await $api("/geral/areas-cientificas", {
      method: "GET",
    });

    areas_cientificas.value = res.map((area) => ({
      id: area.id,
      nome: area.nome,
    }));

    areas_cientificas.value = areas_cientificas.value.map((area) => ({
      title: area.nome,
      value: area.nome,
    }));
  } catch (err) {
    console.error("Erro ao buscar areas cientificas:", err);
    snackbarMessage.value =
      "Erro ao buscar buscar areas cientificas. Tente novamente mais tarde.";
    snackbarColor.value = "error";
    snackbar.value = true;
  }
};

const buscarDistritos = async () => {
  try {
    const res = await $api("/distritos", {
      method: "GET",
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
    snackbarMessage.value =
      "Erro ao buscar distritos. Tente novamente mais tarde.";
    snackbarColor.value = "error";
    snackbar.value = true;
  }
};

buscarDistritos();
buscarAreas();
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
      title="Cadastrar Professor"
      @cancel="closeNavigationDrawer"
    />

    <VDivider />

    <PerfectScrollbar :options="{ wheelPropagation: false }">
      <VCard flat>
        <VCardText>
     
          <VForm ref="refForm" v-model="isFormValid" @submit.prevent="onSubmit">
            <VRow>
             
              <VCol cols="12">
                <VTextField
                  v-model="nomeCompleto"
                  label="Nome Completo"
                  placeholder="Nome Completo"
                  :rules="[requiredValidator]"
                />
              </VCol>

             
              <VCol cols="12">
                <VTextField
                  v-model="dataNascimento"
                  label="Data de Nascimento"
                  type="date"
                  :rules="[requiredValidator]"
                  placeholder="Selecione a data"
                />
              </VCol>

             
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

              <VCol cols="12">
                <VSelect
                  v-model="sexo"
                  :items="opcoesSexo"
                  label="Sexo"
                  placeholder="Selecione o sexo"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <VCol cols="12">
                <VTextField
                  v-model="bilheteIdentificacao"
                  label="Bilhete de Identificação"
                  placeholder="Número do Bilhete"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <VCol cols="12">
                <VTextField
                  v-model="nomeDoPai"
                  label="Nome do Pai"
                  placeholder="Nome do Pai"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <VCol cols="12">
                <VTextField
                  v-model="nomeDaMae"
                  label="Nome da Mãe"
                  placeholder="Nome da Mãe"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <VCol cols="12">
                <VAutocomplete
                  v-model="estadoCivil"
                  :items="opcoesEstadoCivil"
                  label="Estado Civil"
                  placeholder="Selecione o estado Civil"
                  :rules="[requiredValidator]"
                   clearable
                  clear-icon="ri-close-line"
                />
              </VCol>

              <VCol cols="12">
                <VAutocomplete
                  v-model="religiao"
                  :items="opcoesReligiao"
                  label="Religião"
                  placeholder="Selecione a religião"
                  :rules="[requiredValidator]"
                   clearable
                  clear-icon="ri-close-line"
                />
              </VCol>

              <VCol cols="12">
                <VAutocomplete
                  v-model="grupoSanguineo"
                  :items="opcoesGrupoSanguineo"
                  label="Grupo Sanguíneo"
                  placeholder="Selecione o grupo sanguíneo"
                />
              </VCol>

              <VCol cols="12">
                <VTextField
                  v-model="endereco"
                  label="Endereço"
                  placeholder="Endereço"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <VCol cols="12">
                <VAutocomplete
                  v-model="selectedArea"
                  label="Area de Formacao"
                  placeholder="Selecionar Area de Formacao"
                  :items="areas_cientificas"
                  clearable
                  clear-icon="ri-close-line"
                />
              </VCol>

              <VCol cols="12">
                <VTextField
                  v-model="escolaAnterior"
                  label="Escola Anterior"
                  placeholder="Escola Anterior"
                  :rules="[requiredValidator]"
                />
              </VCol>

              <VCol cols="12">
                <VTextField
                  v-model="email"
                  label="Email"
                  placeholder="Email"
                  :rules="[requiredValidator, emailValidator]"
                />
              </VCol>

              <VCol cols="12">
                <VTextField
                  v-model="numeroTelefonePrincipal"
                  label="Número de Telefone Principal"
                  placeholder="Telefone"
                  :rules="[requiredValidator, integerValidator]"
                />
              </VCol>

              <VCol cols="12">
                <VTextField
                  v-model="numeroTelefoneAlternativo"
                  label="Número de Telefone Secundario"
                  placeholder="Telefone"
                  :rules="[requiredValidator, integerValidator]"
                />
              </VCol>

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
