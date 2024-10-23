<script setup>
const searchQuery = ref("");
const selectedMetodoPagamento = ref(null);
const selectedTipoPagamento = ref(null);
const selectedEstado = ref(null);

const itemsPerPage = ref(8);
const page = ref(1);
const sortBy = ref();
const orderBy = ref();
const selectedRows = ref([]);

const pagamentos = ref([]);
const metodos_pagamento = ref([]);
const tipos_pagamento = ref([]);
const filteredPagamentos = ref([]);
const total_pagamentos = ref(0);
const total_matriculas = ref(0);
const total_mensalidades = ref(0);
const total_multas = ref(0);


const mini_estatisticas = ref([
  {
    title: "Todos pagamentos",
    value: total_pagamentos,
    desc: "pagamentos cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
  {
    title: "Matriculas",
    value: total_matriculas,
    desc: "pagamentos Activos",
    icon: "ri-user-follow-line",
    iconColor: "success",
  },
  {
    title: "Mensalidades",
    value: total_mensalidades,
    desc: "pagamentos transferidos",
    icon: "ri-user-search-line",
    iconColor: "warning",
  },
  {
    title: "Multas",
    value: total_multas,
    desc: "pagamentos cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
]);

const headers = [
  { title: "Pagamento", key: "id", sortable: true },
  { title: "Aluno", key: "aluno", sortable: true },
  { title: "Valor", key: "valor", sortable: true },
  { title: "Metodo ", key: "metodoPagamento", sortable: true },
  { title: "Tipo de Pagamento", key: "tipoPagamento", sortable: true },
  { title: "Data", key: "dataPagamento", sortable: true },
  { title: "Responsavel", key: "responsavel", sortable: true },
  { title: "Estado", key: "estado", sortable: true },
  { title: "Ações", key: "actions", sortable: false },
];

const estado = [
  { title: "Activo", value: "Activo" },
  { title: "Transferido", value: "Transferido" },
  { title: "Graduado", value: "Graduado" },
  { title: "Desistente", value: "Desistente" },
];

const paginatedPagamentos = computed(() => {
  const start = (page.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return filteredPagamentos.value.slice(start, end);
});

const fetchMetodosPagamento = async () => {
  try {
    const res = await $api("/metodos_pagamento", {
      method: "GET",
    });

    metodos_pagamento.value = res.map((metodo_pagamento) => ({
      id: metodo_pagamento.id,
      nome: metodo_pagamento.nome,
    }));

    filterPagamentos();
    metodos_pagamento.value = metodos_pagamento.value.map((metodo_pagamento) => ({
      title: metodo_pagamento.nome,
      value: metodo_pagamento.nome,
    }));
  } catch (err) {
    console.error("Erro ao buscar metodos de pagamentos:", err);
  }
};

const fetchTiposPagamento = async () => {
  try {
    const res = await $api("/tipos_pagamento", {
      method: "GET",
    });

    tipos_pagamento.value = res.map((tipo_pagamento) => ({
      id: tipo_pagamento.id,
      nome: tipo_pagamento.nome,
    }));

    filterPagamentos();
    tipos_pagamento.value = tipos_pagamento.value.map((tipo_pagamento) => ({
      title: tipo_pagamento.nome,
      value: tipo_pagamento.nome,
    }));
  } catch (err) {
    console.error("Erro ao buscarar tipos de pagamentos:", err);
  }
};

const fetchPagamentos = async () => {
  try {
    const res = await $api("/pagamentos", {
      method: "GET",
    });

    pagamentos.value = res.map((pagamento) => ({
      id: pagamento.id,
      referencia: pagamento.referencia,
      aluno: pagamento.aluno,
      id_aluno: pagamento.id_aluno,
      valor: pagamento.valor,
      metodoPagamento: pagamento.metodoPagamento,
      dataPagamento: pagamento.dataPagamento,
      responsavel: pagamento.responsavel,
      id_responsavel: pagamento.id_responsavel,
      observacao: pagamento.observacao,
      estado: pagamento.estado,
      tipoPagamento: pagamento.tipoPagamento,
    
    }));

    filterPagamentos();
  } catch (err) {
    console.error("Erro ao buscar encarregados:", err);
  }
};

const filterPagamentos = () => {
  filteredPagamentos.value = pagamentos.value.filter((pagamento) => {
    const matchesSearch =
    pagamento.aluno
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
        pagamento.responsavel
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
        pagamento.metodoPagamento
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
        pagamento.tipoPagamento
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
        pagamento.estado
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
        pagamento.dataPagamento
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase());

    const matchesDistrito =
      !selectedMetodoPagamento.value ||
      pagamento.metodoPagamento === selectedMetodoPagamento.value;
    const matchesEstado =
      !selectedEstado.value || pagamento.estado === selectedEstado.value;
    const matcheSectotTrabalho =
      !selectedTipoPagamento.value ||
      pagamento.tipoPagamento === selectedTipoPagamento.value;

    return (
      matchesSearch && matchesDistrito && matchesEstado && matcheSectotTrabalho
    );
  });
};

const totalPagamentos = async () => {
  try {
    const res = await $api("/pagamentos/totais", {
      method: "GET",
    });

    total_pagamentos.value = res;
  } catch (err) {
    console.error("Erro ao buscar encarregados:", err);
  }
};

const totalMatriculas = async () => {
  try {
    const res = await $api(`/pagamentos/tipo/Pagamento de Matrícula`, {
      method: "GET",
    });

    total_matriculas.value = res;
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
  [searchQuery, selectedMetodoPagamento, selectedTipoPagamento, selectedEstado],
  filterPagamentos
);

const atualizarDados = () => {
  fetchPagamentos();
  fetchTiposPagamento();
  fetchMetodosPagamento();
  totalPagamentos();
  totalMatriculas();
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
        <VCardTitle>Filtrar Pagamentos</VCardTitle>
      </VCardItem>
      <VCardText>
        <VRow>
          <VCol cols="12" sm="4">
            <VAutocomplete
              v-model="selectedMetodoPagamento"
              label="Seleccionar o metodo de pagamento"
              placeholder="Seleccionar o metodo de pagamento"
              :items="metodos_pagamento"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
          <VCol cols="12" sm="4">
            <VAutocomplete
              v-model="selectedTipoPagamento"
              label="Seleccionar o tipo de pagamento"
              placeholder="Seleccionar tipo de pagamento"
              :items="tipos_pagamento"
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
              placeholder="Buscar pagamento"
              density="compact"
            />
          </div>

          <VBtn @click="registarPagamento()"
            >Cadastrar Encarregado</VBtn
          >
        </div>
      </VCardText>
    </VCard>
    <VCard class="mb-6">
      <VDataTableServer
        v-model:model-value="selectedRows"
        :items="paginatedPagamentos"
        item-value="id"
        :items-per-page="itemsPerPage"
        :items-length="filteredPagamentos.length"
        :headers="headers"
        show-select
        class="text-no-wrap rounded-0"
        @update:options="updateOptions"
      >
        <template #item.actions="{ item }">
          <IconBtn
            size="small"
            color="info"
            :to="{
              name: 'pagamentos-detalhes-id',
              params: { id: item.id },
            }"
          >
            <VIcon icon="ri-eye-line" />
          </IconBtn>
          <IconBtn
            size="small"
            color="warning"
            :to="{
              name: 'pagamentos-pagamento-editar-id',
              params: { id: item.id },
            }"
          >
            <VIcon icon="ri-edit-line" />
          </IconBtn>
        </template>
      </VDataTableServer>
    </VCard>
  </section>
</template>

<style lang="scss" scoped>
.app-user-search-filter {
  inline-size: 15.625rem;
}
</style>
