<script setup>
import EditarFuncionario from "@/views/utilizadores/funcionarios/forms/CadastrarFuncionario.vue";
import CadastrarFuncionario from "@/views/utilizadores/funcionarios/forms/CadastrarFuncionario.vue";

const searchQuery = ref("");
const selectedCargo = ref(null);
const selectedDepartamento = ref(null);
const selectedEstado = ref(null);

const itemsPerPage = ref(8);
const page = ref(1);
const sortBy = ref();
const orderBy = ref();
const selectedRows = ref([]);
const alunos = ref([]);
const cargos = ref([]);
const departamentos = ref([]);
const filteredFuncionarios = ref([]);
const total_funcionarios = ref(0);
const total_activos = ref(0);
const total_transferidos = ref(0);
const total_reformados = ref(0);

const isCadastrarFuncionarioVisible = ref(false);
const isEditarEncarregadoVisible = ref(false);

const mini_estatisticas = ref([
  {
    title: "Todos funcionarios",
    value: total_funcionarios,
    desc: "funcionarios cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
  {
    title: "Activos",
    value: total_activos,
    desc: "funcionarios Activos",
    icon: "ri-user-follow-line",
    iconColor: "success",
  },
  {
    title: "Transferidos",
    value: total_transferidos,
    desc: "funcionarios transferidos",
    icon: "ri-user-search-line",
    iconColor: "warning",
  },
  {
    title: "Reformados",
    value: total_reformados,
    desc: "funcionarios cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
]);

const headers = [
  { title: "Nome Completo", key: "nome", sortable: true },
  { title: "Departamento", key: "departamento", sortable: true },
  { title: "Cargo", key: "cargo", sortable: true },
  { title: "Sexo", key: "sexo", sortable: true },
  { title: "Nº documento", key: "bilheteIdentificacao", sortable: true },
  { title: "Nº Telefone", key: "numeroTelefonePrincipal", sortable: true },
  { title: "Estado", key: "estado", sortable: true },
  { title: "Ações", key: "actions", sortable: false },
];

const estado = [
  { title: "Activo", value: "Activo" },
  { title: "Transferido", value: "Transferido" },
  { title: "Graduado", value: "Graduado" },
  { title: "Desistente", value: "Desistente" },
];

const paginatedFuncionarios = computed(() => {
  const start = (page.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return filteredFuncionarios.value.slice(start, end);
});

const fetchCargos = async () => {
  try {
    const res = await $api("/cargos", {
      method: "GET",
    });

    cargos.value = res.map((distrito) => ({
      id: distrito.id,
      nome: distrito.nome,
      provincia: distrito.provincia,
    }));

    filterFuncionarios();
    cargos.value = cargos.value.map((distrito) => ({
      title: distrito.nome,
      value: distrito.nome,
    }));
  } catch (err) {
    console.error("Erro ao buscar funcionarios:", err);
  }
};

const fetchDepartamentos = async () => {
  try {
    const res = await $api("/departamentos", {
      method: "GET",
    });

    departamentos.value = res.map((area) => ({
      id: area.id,
      nome: area.nome,
    }));

    filterFuncionarios();
    departamentos.value = departamentos.value.map((area) => ({
      title: area.nome,
      value: area.nome,
    }));
  } catch (err) {
    console.error("Erro ao buscar funcionarios:", err);
  }
};

const fetchFuncionarios = async () => {
  try {
    const res = await $api("/funcionarios", {
      method: "GET",
    });

    alunos.value = res.map((funcionario) => ({
      id: funcionario.id,
      nome: funcionario.nomeCompleto,
      dataNascimento: funcionario.dataNascimento,
      distritoNascimento: funcionario.distritoNascimento,
      provinciaNascimento: funcionario.provinciaNascimento,
      bilheteIdentificacao: funcionario.bilheteIdentificacao,
      departamento: funcionario.departamento,
      cargo: funcionario.cargo,
      areaFormacao: funcionario.areaFormacao,
      numeroTelefonePrincipal: funcionario.numeroTelefonePrincipal,
      sexo: funcionario.sexo,
      estado: funcionario.estado,
    }));

    filterFuncionarios();
  } catch (err) {
    console.error("Erro ao buscar funcionarios:", err);
  }
};

const filterFuncionarios = () => {
  filteredFuncionarios.value = alunos.value.filter((funcionario) => {
    const matchesSearch =
    funcionario.areaFormacao
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      funcionario.nome
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      funcionario.cargo
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      funcionario.bilheteIdentificacao
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      funcionario.dataNascimento
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      funcionario.estado
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      funcionario.departamento
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase());

    const matchesCargo =
      !selectedCargo.value ||
      funcionario.cargo === selectedCargo.value;
    const matchesEstado =
      !selectedEstado.value || funcionario.estado === selectedEstado.value;
    const matcheDepartamento =
      !selectedDepartamento.value ||
      funcionario.departamento === selectedDepartamento.value;

    return (
      matchesSearch && matchesCargo && matchesEstado && matcheDepartamento
    );
  });
};

const totalFuncionarios = async () => {
  try {
    const res = await $api("/funcionarios/totais", {
      method: "GET",
    });

    total_funcionarios.value = res;
  } catch (err) {
    console.error("Erro ao buscar funcionarios:", err);
  }
};

const cadastrarFuncionario = async (userData) => {
  await $api("/funcionarios/cadastrar", {
    method: "POST",
    body: userData,
  });

  fetchFuncionarios();
};

const totalActivos = async () => {
  try {
    const res = await $api("/funcionarios/estado/Activo", {
      method: "GET",
    });

    total_activos.value = res;
  } catch (err) {
    console.error("Erro ao buscar funcionarios:", err);
  }
};

const totaTransferidos = async () => {
  try {
    const res = await $api("/funcionarios/estado/Transferido", {
      method: "GET",
    });

    total_transferidos.value = res;
  } catch (err) {
    console.error("Erro ao buscar funcionarios:", err);
  }
};

const totalReformados = async () => {
  try {
    const res = await $api("/funcionarios/estado/Reformado", {
      method: "GET",
    });

    total_reformados.value = res;
  } catch (err) {
    console.error("Erro ao buscar funcionarios:", err);
  }
};

const updateOptions = (options) => {
  page.value = options.page;
  sortBy.value = options.sortBy[0]?.key;
  orderBy.value = options.sortBy[0]?.order;
};

watch(
  [searchQuery, selectedCargo, selectedDepartamento, selectedEstado],
  filterFuncionarios
);

const atualizarDados = () => {
  fetchFuncionarios();
  totalFuncionarios();
  totaTransferidos();
  totalActivos();
  fetchDepartamentos();
  totalReformados();
  fetchCargos();
};

atualizarDados();
</script>

<template>
  <section>
    <div class="d-flex mb-6">
      <VRow>
        <template v-for="data in mini_estatisticas" :key="id">
          <VCol cols="12" md="3" sm="6">
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
        <VCardTitle>Filtrar Funcionarios</VCardTitle>
      </VCardItem>
      <VCardText>
        <VRow>
          <VCol cols="12" sm="4">
            <VAutocomplete
              v-model="selectedCargo"
              label="Seleccionar o cargo"
              placeholder="Seleccionar o cargo"
              :items="cargos"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
          <VCol cols="12" sm="4">
            <VAutocomplete
              v-model="selectedDepartamento"
              label="Seleccionar departamento"
              placeholder="Seleccionar departamento"
              :items="departamentos"
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
          prepend-icon="ri-refresh-fill"
          @click="atualizarDados()"
          >Recarregar Dados</VBtn
        >
        <VSpacer />
        <div class="d-flex align-center gap-4 flex-wrap">
          <div class="app-user-search-filter">
            <VTextField
              v-model="searchQuery"
              placeholder="Buscar funcionario..."
              density="compact"
            />
          </div>

          <VBtn @click="isCadastrarFuncionarioVisible = true"
            >Cadastrar Funcionario</VBtn
          >
        </div>
      </VCardText>
    </VCard>
    <VCard class="mb-6">
      <VDataTableServer
        v-model:model-value="selectedRows"
        :items="paginatedFuncionarios"
        item-value="id"
        :items-per-page="itemsPerPage"
        :items-length="filteredFuncionarios.length"
        :headers="headers"
        show-select
        class="text-no-wrap rounded-0"
        @update:options="updateOptions"
      >
        <template #item.actions="{ item }">
          <IconBtn
            size="small"
            :to="{
              name: 'utilizadores-funcionarios-detalhes-id',
              params: { id: item.id },
            }"
          >
            <VIcon icon="ri-eye-line" />
          </IconBtn>

          <VBtn
            icon="ri-edit-2-line"
            :icon-color="success"
            variant="plain"
            @click="isEditarEncarregadoVisible = true"
          />
        </template>
      </VDataTableServer>
    </VCard>

    <CadastrarFuncionario
      v-model:isDrawerOpen="isCadastrarFuncionarioVisible"
      @user-data="cadastrarFuncionario"
    />

    <EditarFuncionario
      v-model:isDrawerOpen="isCadastrarFuncionarioVisible"
      @user-data="cadastrarFuncionario"
    />
  </section>
</template>

<style lang="scss" scoped>
.app-user-search-filter {
  inline-size: 15.625rem;
}
</style>
