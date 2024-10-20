<script setup>
import CadastrarProfessor from "@/views/utilizadores/estudantes/CadastrarEstudante.vue";
import EditarProfessor from "@/views/utilizadores/estudantes/EditarEstudante.vue";

const searchQuery = ref("");
const selectedDistrito = ref(null);
const selectedSexo = ref(null);
const selectedEstado = ref(null);

const itemsPerPage = ref(5);
const page = ref(1);
const sortBy = ref();
const orderBy = ref();
const selectedRows = ref([]);
const alunos = ref([]);
const distritos = ref([]);
const filteredAlunos = ref([]);

const total_professores = ref(0);
const total_activos = ref(0);
const total_transferidos = ref(0);
const total_expulsos = ref(0);
const total_suspensos = ref(0);
const total_reformados = ref(0);

const isCadastrarProfessorVisible = ref(false);
const isEditarProfessorVisible = ref(false);

const mini_estatisticas = ref([
  {
    title: "Todos Professores",
    value: total_professores,
    desc: "Professores cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
  {
    title: "Activos",
    value: total_activos,
    desc: "Professores Activos",
    icon: "ri-user-follow-line",
    iconColor: "success",
  },
  {
    title: "Transferidos",
    value: total_transferidos,
    desc: "Professores transferidos",
    icon: "ri-user-search-line",
    iconColor: "warning",
  },
  {
    title: "Reformados",
    value: total_reformados,
    desc: "Professores cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
  {
    title: "Suspensos",
    value: total_suspensos,
    desc: "Professores transferidos",
    icon: "ri-user-search-line",
    iconColor: "warning",
  },
  {
    title: "Expulsos",
    value: total_expulsos,
    desc: "Professores transferidos",
    icon: "ri-user-search-line",
    iconColor: "warning",
  },
]);

const headers = [
  { title: "Professor", key: "id", sortable: true },
  { title: "Nome Completo", key: "nome", sortable: true },
  { title: "Data Nascimento", key: "dataNascimento", sortable: true },
  { title: "Provincia", key: "provinciaNascimento", sortable: true },
  { title: "Distrito", key: "distritoNascimento", sortable: true },
  { title: "Sexo", key: "sexo", sortable: true },
  { title: "Nº documento", key: "bilheteIdentificacao", sortable: true },
  { title: "Nº Telefone", key: "numeroTelefonePrincipal", sortable: true },
  { title: "Estado", key: "estado", sortable: true },
  { title: "Ações", key: "actions", sortable: false },
];

const sexo = [
  { title: "Masculino", value: "M" },
  { title: "Feminino", value: "F" },
];

const estado = [
  { title: "Matriculado", value: "Matriculado" },
  { title: "Transferido", value: "Transferido" },
  { title: "Graduado", value: "Graduado" },
  { title: "Suspenso", value: "Suspenso" },
  { title: "Expulso", value: "Expulso" },
  { title: "Desistente", value: "Desistente" },
];

const paginatedAlunos = computed(() => {
  const start = (page.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return filteredAlunos.value.slice(start, end);
});

const fetchDistritos = async () => {
  try {
    const res = await $api("/distritos", {
      method: "GET",
    });

    distritos.value = res.map((distrito) => ({
      id: distrito.id,
      nome: distrito.nome,
      provincia: distrito.provincia,
    }));

    filterProfessores();
    distritos.value = distritos.value.map((distrito) => ({
      title: distrito.nome,
      value: distrito.nome,
    }));
  } catch (err) {
    console.error("Erro ao buscar professores:", err);
  }
};

const fetchProfessores = async () => {
  try {
    const res = await $api("/professores", {
      method: "GET",
    });

    alunos.value = res.map((professor) => ({
      id: professor.id,
      nome: professor.nomeCompleto,
      dataNascimento: professor.dataNascimento,
      distritoNascimento: professor.distritoNascimento,
      provinciaNascimento: professor.provinciaNascimento,
      bilheteIdentificacao: professor.bilheteIdentificacao,
      numeroTelefonePrincipal: professor.numeroTelefonePrincipal,
      sexo: professor.sexo,
      estado: professor.estado,
    }));

    filterProfessores();
  } catch (err) {
    console.error("Erro ao buscar professores:", err);
  }
};

const filterProfessores = () => {
  filteredAlunos.value = alunos.value.filter((professor) => {
    const matchesSearch =
      professor.nome.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      professor.distritoNascimento
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      professor.bilheteIdentificacao
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      professor.dataNascimento
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      professor.estado
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      professor.sexo.toLowerCase().includes(searchQuery.value.toLowerCase());

    const matchesDistrito =
      !selectedDistrito.value ||
      professor.distritoNascimento === selectedDistrito.value;
    const matchesEstado =
      !selectedEstado.value || professor.estado === selectedEstado.value;
    const matchesSexo =
      !selectedSexo.value || professor.sexo === selectedSexo.value;

    return matchesSearch && matchesDistrito && matchesEstado && matchesSexo;
  });
};

const totalProfessores = async () => {
  try {
    const res = await $api("/professores/totais", {
      method: "GET",
    });

    total_professores.value = res;
  } catch (err) {
    console.error("Erro ao buscar professores:", err);
  }
};

const cadastrarProfessor = async (userData) => {
  await $api("/professores/cadastrar", {
    method: "POST",
    body: userData,
  });

  fetchProfessores();
};

const totalActivos = async () => {
  try {
    const res = await $api("/professores/estado/Activo", {
      method: "GET",
    });

    total_activos.value = res;
  } catch (err) {
    console.error("Erro ao buscar professores:", err);
  }
};

const totaTransferidos = async () => {
  try {
    const res = await $api("/professores/estado/Transferido", {
      method: "GET",
    });

    total_transferidos.value = res;
  } catch (err) {
    console.error("Erro ao buscar professores:", err);
  }
};

const totalReformados = async () => {
  try {
    const res = await $api("/professores/estado/Reformado", {
      method: "GET",
    });

    total_reformados.value = res;
  } catch (err) {
    console.error("Erro ao buscar professores:", err);
  }
};

const totalSuspensos = async () => {
  try {
    const res = await $api("/professores/estado/Suspenso", {
      method: "GET",
    });

    total_suspensos.value = res;
  } catch (err) {
    console.error("Erro ao buscar professores:", err);
  }
};

const totalExpulsos = async () => {
  try {
    const res = await $api("/professores/estado/Graduado", {
      method: "GET",
    });

    total_expulsos.value = res;
  } catch (err) {
    console.error("Erro ao buscar professores:", err);
  }
};

const updateOptions = (options) => {
  page.value = options.page;
  sortBy.value = options.sortBy[0]?.key;
  orderBy.value = options.sortBy[0]?.order;
};

watch(
  [searchQuery, selectedDistrito, selectedSexo, selectedEstado],
  filterProfessores
);

const atualizarDados = () => {
  fetchProfessores();
  totalProfessores();
  totaTransferidos();
  totalActivos();
  totalReformados();
  totalExpulsos();
  totalSuspensos();
  fetchDistritos();
};

atualizarDados();
</script>

<template>
  <section>
    <div class="d-flex mb-6">
      <VRow>
        <template v-for="data in mini_estatisticas" :key="id">
          <VCol cols="12" md="4" sm="6">
            <VCard>
              <VCardText>
                <div class="d-flex justify-space-between">
                  <div class="d-flex flex-column gap-y-1">
                    <span class="text-base text-high-emphasis">{{
                      data.title
                    }}</span>
                    <h4 class="text-h4 d-flex align-center gap-2">
                      {{ data.value }}
                    </h4>
                    <p class="text-sm mb-0">{{ data.desc }}</p>
                  </div>
                  <VAvatar
                    :color="data.iconColor"
                    variant="tonal"
                    rounded
                    size="42"
                  >
                    <VIcon :icon="data.icon" size="26" />
                  </VAvatar>
                </div>
              </VCardText>
            </VCard>
          </VCol>
        </template>
      </VRow>
    </div>

    <VCard class="mb-6">
      <VCardItem class="pb-4">
        <VCardTitle>Filtrar Professores</VCardTitle>
      </VCardItem>
      <VCardText>
        <VRow>
          <VCol cols="12" sm="4">
            <VAutocomplete
              v-model="selectedDistrito"
              label="Seleccionar o distrito de nascenca"
              placeholder="Seleccionar tipo de Utilizador"
              :items="distritos"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
          <VCol cols="12" sm="4">
            <VSelect
              v-model="selectedSexo"
              label="Selecionar Sexo"
              placeholder="Escolher Sexo"
              :items="sexo"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
          <VCol cols="12" sm="4">
            <VSelect
              v-model="selectedEstado"
              label="Selecionar Estado"
              placeholder="Escolher Estado"
              :items="estado"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
        </VRow>
      </VCardText>
      <VDivider />

      <VCardText class="d-flex flex-wrap gap-4 align-center">
        <VBtn
          variant="outlined"
          color="secondary"
          prepend-icon="ri-refresh-line"
          @click="atualizarDados()"
          >Recarregar Dados</VBtn
        >
        <VSpacer />
        <div class="d-flex align-center gap-4 flex-wrap">
          <div class="app-user-search-filter">
            <VTextField
              v-model="searchQuery"
              placeholder="Buscar aluno"
              density="compact"
            />
          </div>

          <VBtn @click="isCadastrarProfessorVisible = true"
            >Cadastrar Professor</VBtn
          >
        </div>
      </VCardText>
    </VCard>
    <VCard class="mb-6">
      <VDataTableServer
        v-model:model-value="selectedRows"
        :items="paginatedAlunos"
        item-value="id"
        :items-per-page="itemsPerPage"
        :items-length="filteredAlunos.length"
        :headers="headers"
        show-select
        class="text-no-wrap rounded-0"
        @update:options="updateOptions"
      >
        <template #item.actions="{ item }">
          <IconBtn
            size="small"
            :to="{
              name: 'utilizadores-professores-detalhes-id',
              params: { id: item.id },
            }"
          >
            <VIcon icon="ri-eye-line" />
          </IconBtn>

          <VBtn
            icon="ri-edit-2-line"
            :icon-color="success"
            variant="plain"
            @click="isEditarProfessorVisible = true"
          />
        </template>
      </VDataTableServer>
    </VCard>
    <!-- Cadastrar estudante modal -->
    <CadastrarProfessor
      v-model:isDrawerOpen="isCadastrarProfessorVisible"
      @user-data="cadastrarProfessor"
    />

    <EditarProfessor
      v-model:isDrawerOpen="isCadastrarProfessorVisible"
      @user-data="cadastrarProfessor"
    />
  </section>
</template>

<style lang="scss" scoped>
.app-user-search-filter {
  inline-size: 15.625rem;
}
</style>
