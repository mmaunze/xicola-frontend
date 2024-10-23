<script setup>
const distritos = ref([]);
const selectedDistrito = ref(null);

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

const props = defineProps({
  userData: {
    type: Object,
    required: false,
    default: () => ({
      avatar: "",
      nomeCompleto: "",
      dataNascimento: "",
      distritoNascimento: "",
      provinciaNascimento: "",
      nomeDoPai: "",
      nomeDaMae: "",
      religiao: "",
      grupoSanguineo: "",
      endereco: "",
      dataRegisto: "",
      escolaAnterior: "",
      bilheteIdentificacao: "",
      numeroTelefonePrincipal: "",
      sexo: "",
      estado: "",
      email: "",
    }),
  },
  isDialogVisible: {
    type: Boolean,
    required: true,
  },
});

const emit = defineEmits(["submit", "update:isDialogVisible"]);

const professorData = ref(structuredClone(toRaw(props.userData)));

watch(
  () => props,
  () => {
    professorData.value = structuredClone(toRaw(props.userData));
  }
);

const onFormSubmit = () => {
  emit("update:isDialogVisible", false);
  emit("submit", professorData.value);
};

const onFormReset = () => {
  professorData.value = structuredClone(toRaw(props.userData));
  emit("update:isDialogVisible", false);
};

const dialogVisibleUpdate = (val) => {
  emit("update:isDialogVisible", val);
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
      value: distrito.id,
    }));
  } catch (err) {
    console.error("Erro ao buscar distritos:", err);
  }
};

buscarDistritos();
</script>

<template>
  <VDialog
    :width="$vuetify.display.smAndDown ? 'auto' : 900"
    :model-value="props.isDialogVisible"
    @update:model-value="dialogVisibleUpdate"
  >
    <VCard class="pa-sm-11 pa-3">
      <DialogCloseBtn variant="text" size="default" @click="onFormReset" />

      <VCardText class="pt-5">
        <div class="text-center pb-6">
          <h4 class="text-h4 mb-2">Editar Informações do Professor</h4>
          <div class="text-body-1">
            Todas as actualizações nas informações do professor serão auditadas.
          </div>
        </div>

        <!-- Form -->
        <VForm class="mt-4" @submit.prevent="onFormSubmit">
          <VRow>
            <!-- Nome Completo -->
            <VCol cols="12">
              <VTextField
                v-model="professorData.nomeCompleto"
                label="Nome Completo"
                placeholder="Ex: João Silva"
              />
            </VCol>

            <!-- Data de Nascimento -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="professorData.dataNascimento"
                label="Data de Nascimento"
                type="datepicker"
                placeholder="Ex: 2020-12-29"
              />
            </VCol>

            <!-- Sexo -->
            <VCol cols="12" md="6">
              <VSelect
                v-model="professorData.sexo"
                :items="['Masculino', 'Feminino']"
                label="Sexo"
                placeholder="Selecione o sexo"
              />
            </VCol>

            <!-- Nome do Pai -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="professorData.nomeDoPai"
                label="Nome do Pai"
                placeholder="Ex: José Silva"
              />
            </VCol>

            <!-- Nome da Mãe -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="professorData.nomeDaMae"
                label="Nome da Mãe"
                placeholder="Ex: Maria Silva"
              />
            </VCol>

            <!-- Distrito de Nascimento -->
            <VCol cols="12" md="6">
              <VAutocomplete
                v-model="selectedDistrito"
                label="Distrito de Nascimento"
                placeholder="Selecionar Distrito de Nascimento"
                :items="distritos"
                clearable
                clear-icon="ri-close-line"
              />
            </VCol>

            <!-- Grupo Sanguíneo -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="professorData.grupoSanguineo"
                label="Grupo Sanguíneo"
                placeholder="Ex: O+"
              />
            </VCol>

            <!-- Religião -->
            <VCol cols="12" md="6">
              <VAutocomplete
                v-model="professorData.religiao"
                label="Religião"
                placeholder="Ex: Católica"
                :items="opcoesReligiao"
                clearable
                clear-icon="ri-close-line"
              />
            </VCol>

            <!-- Bilhete de Identificação -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="professorData.bilheteIdentificacao"
                label="Bilhete de Identificação"
                placeholder="Ex: 123456789"
              />
            </VCol>

            <VCol cols="12" md="6">
              <VTextField
                v-model="professorData.numeroTelefonePrincipal"
                label="Número de Telefone"
                placeholder="Ex: +351 912345678"
              />
            </VCol>

            <VCol cols="12" md="6">
              <VTextField
                v-model="professorData.email"
                label="email"
                type="email"
                placeholder="email@exemplo.com"
              />
            </VCol>

            <VCol cols="12">
              <VTextField
                v-model="professorData.endereco"
                label="Endereço"
                placeholder="Ex: Rua ABC, 123, Lisboa"
              />
            </VCol>

            <!-- Escola Anterior -->
            <VCol cols="12">
              <VTextField
                v-model="professorData.escolaAnterior"
                label="Escola Anterior"
                placeholder="Ex: Escola Secundária ABC"
              />
            </VCol>

            <!-- Submit and Cancel -->
            <VCol cols="12" class="d-flex flex-wrap justify-center gap-4">
              <VBtn type="submit"> Actualizar </VBtn>

              <VBtn color="secondary" variant="outlined" @click="onFormReset">
                Cancelar
              </VBtn>
            </VCol>
          </VRow>
        </VForm>
      </VCardText>
    </VCard>
  </VDialog>
</template>
