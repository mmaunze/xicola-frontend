<script setup>
import EditarEncarregado from "@/views/utilizadores/estudantes/EditarAluno.vue";
import CadastrarEncarregado from "@/views/utilizadores/professores/forms/CadastrarProfessor.vue";

const searchQuery = ref("");
const selectedDistrito = ref(null);
const selectedASectorTrabalho = ref(null);
const selectedEstado = ref(null);

const itemsPerPage = ref(8);
const page = ref(1);
const sortBy = ref();
const orderBy = ref();
const selectedRows = ref([]);
const alunos = ref([]);
const distritos = ref([]);
const sectores_trabalho = ref([]);
const filteredEncarregados = ref([]);
const total_encarregados = ref(0);
const total_activos = ref(0);
const total_transferidos = ref(0);
const total_reformados = ref(0);

const isCadastrarEncarregadoVisible = ref(false);
const isEditarEncarregadoVisible = ref(false);

const mini_estatisticas = ref([
  {
    title: "Todos encarregados",
    value: total_encarregados,
    desc: "encarregados cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
  {
    title: "Activos",
    value: total_activos,
    desc: "encarregados Activos",
    icon: "ri-user-follow-line",
    iconColor: "success",
  },
  {
    title: "Transferidos",
    value: total_transferidos,
    desc: "encarregados transferidos",
    icon: "ri-user-search-line",
    iconColor: "warning",
  },
  {
    title: "Reformados",
    value: total_reformados,
    desc: "encarregados cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
]);

const headers = [
  { title: "Encarregado", key: "id", sortable: true },
  { title: "Nome Completo", key: "nome", sortable: true },
  { title: "Data Nascimento", key: "dataNascimento", sortable: true },
  { title: "Distrito", key: "distritoNascimento", sortable: true },
  { title: "Sector de Trabalho", key: "sectorTrabalho", sortable: true },
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

const paginatedEncarregados = computed(() => {
  const start = (page.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return filteredEncarregados.value.slice(start, end);
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

    filterEncarregados();
    distritos.value = distritos.value.map((distrito) => ({
      title: distrito.nome,
      value: distrito.nome,
    }));
  } catch (err) {
    console.error("Erro ao buscar encarregados:", err);
  }
};

const fetchSectorTrabalho = async () => {
  try {
    const res = await $api("/sectores_trabalho", {
      method: "GET",
    });

    sectores_trabalho.value = res.map((area) => ({
      id: area.id,
      nome: area.nome,
    }));

    filterEncarregados();
    sectores_trabalho.value = sectores_trabalho.value.map((area) => ({
      title: area.nome,
      value: area.nome,
    }));
  } catch (err) {
    console.error("Erro ao buscar encarregados:", err);
  }
};

const fetchEncarregados = async () => {
  try {
    const res = await $api("/encarregados-educacao", {
      method: "GET",
    });

    alunos.value = res.map((encarregado) => ({
      id: encarregado.id,
      nome: encarregado.nomeCompleto,
      dataNascimento: encarregado.dataNascimento,
      distritoNascimento: encarregado.distritoNascimento,
      provinciaNascimento: encarregado.provinciaNascimento,
      bilheteIdentificacao: encarregado.bilheteIdentificacao,
      sectorTrabalho: encarregado.sectorTrabalho,
      numeroTelefonePrincipal: encarregado.numeroTelefonePrincipal,
      sexo: encarregado.sexo,
      estado: encarregado.estado,
    }));

    filterEncarregados();
  } catch (err) {
    console.error("Erro ao buscar encarregados:", err);
  }
};

const filterEncarregados = () => {
  filteredEncarregados.value = alunos.value.filter((encarregado) => {
    const matchesSearch =
      encarregado.nome
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      encarregado.distritoNascimento
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      encarregado.bilheteIdentificacao
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      encarregado.dataNascimento
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      encarregado.estado
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      encarregado.sectorTrabalho
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase());

    const matchesDistrito =
      !selectedDistrito.value ||
      encarregado.distritoNascimento === selectedDistrito.value;
    const matchesEstado =
      !selectedEstado.value || encarregado.estado === selectedEstado.value;
    const matcheSectotTrabalho =
      !selectedASectorTrabalho.value ||
      encarregado.sectorTrabalho === selectedASectorTrabalho.value;

    return (
      matchesSearch && matchesDistrito && matchesEstado && matcheSectotTrabalho
    );
  });
};

const totalEncarregados = async () => {
  try {
    const res = await $api("/encarregados-educacao/totais", {
      method: "GET",
    });

    total_encarregados.value = res;
  } catch (err) {
    console.error("Erro ao buscar encarregados:", err);
  }
};

const cadastrarEncarregado = async (userData) => {
  await $api("/encarregados-educacao/cadastrar", {
    method: "POST",
    body: userData,
  });

  fetchEncarregados();
};

const totalActivos = async () => {
  try {
    const res = await $api("/encarregados-educacao/estado/Activo", {
      method: "GET",
    });

    total_activos.value = res;
  } catch (err) {
    console.error("Erro ao buscar encarregados:", err);
  }
};

const totaTransferidos = async () => {
  try {
    const res = await $api("/encarregados-educacao/estado/Transferido", {
      method: "GET",
    });

    total_transferidos.value = res;
  } catch (err) {
    console.error("Erro ao buscar encarregados:", err);
  }
};

const totalReformados = async () => {
  try {
    const res = await $api("/encarregados-educacao/estado/Reformado", {
      method: "GET",
    });

    total_reformados.value = res;
  } catch (err) {
    console.error("Erro ao buscar encarregados:", err);
  }
};

const updateOptions = (options) => {
  page.value = options.page;
  sortBy.value = options.sortBy[0]?.key;
  orderBy.value = options.sortBy[0]?.order;
};

watch(
  [searchQuery, selectedDistrito, selectedASectorTrabalho, selectedEstado],
  filterEncarregados
);

const atualizarDados = () => {
  fetchEncarregados();
  totalEncarregados();
  totaTransferidos();
  totalActivos();
  fetchSectorTrabalho();
  totalReformados();
  fetchDistritos();
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
        <VCardTitle>Filtrar Encarregados</VCardTitle>
      </VCardItem>
      <VCardText>
        <VRow>
          <VCol cols="12" sm="4">
            <VAutocomplete
              v-model="selectedDistrito"
              label="Seleccionar o distrito de nascenca"
              placeholder="Seleccionar o distrito de nascenca"
              :items="distritos"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
          <VCol cols="12" sm="4">
            <VAutocomplete
              v-model="selectedASectorTrabalho"
              label="Seleccionar sector trabalho"
              placeholder="Seleccionar sector de trabalho"
              :items="sectores_trabalho"
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
              placeholder="Buscar encarregado"
              density="compact"
            />
          </div>

          <VBtn @click="isCadastrarEncarregadoVisible = true"
            >Cadastrar Encarregado</VBtn
          >
        </div>
      </VCardText>
    </VCard>
    <VCard class="mb-6">
      <VDataTableServer
        v-model:model-value="selectedRows"
        :items="paginatedEncarregados"
        item-value="id"
        :items-per-page="itemsPerPage"
        :items-length="filteredEncarregados.length"
        :headers="headers"
        show-select
        class="text-no-wrap rounded-0"
        @update:options="updateOptions"
      >
        <template #item.actions="{ item }">
          <IconBtn
            size="small"
            :to="{
              name: 'utilizadores-encarregados-detalhes-id',
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

    <CadastrarEncarregado
      v-model:isDrawerOpen="isCadastrarEncarregadoVisible"
      @user-data="cadastrarEncarregado"
    />

    <EditarEncarregado
      v-model:isDrawerOpen="isCadastrarEncarregadoVisible"
      @user-data="cadastrarEncarregado"
    />
  </section>
</template>

<style lang="scss" scoped>
.app-user-search-filter {
  inline-size: 15.625rem;
}
</style>
