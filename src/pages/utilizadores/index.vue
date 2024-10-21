<script setup>
import CadastrarUtilizador from "@/views/utilizadores/list/CadastrarUtilizador.vue";
import { computed, ref, watch } from "vue";

const searchQuery = ref("");
const selectedTipoUtilizador = ref(null);

const itemsPerPage = ref(7);
const page = ref(1);
const sortBy = ref();
const orderBy = ref();
const selectedRows = ref([]);
const alunos = ref([]);

const filteredAlunos = ref([]);

const token = useCookie("accessToken").value;

const total_alunos = ref(0);
const total_utilizadores = ref(0);
const total_professores = ref(0);
const total_funcionarios = ref(0);

const isCadastrarUtilizadorVisible = ref(false);
const isEditarAlunoVisible = ref(false);

const mini_estatisticas = ref([
  {
    title: "Todos Utilizadores",
    value: total_utilizadores,
    desc: "Utilizadores cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
  {
    title: "Alunos",
    value: total_alunos,
    desc: "Alunos cadastrados",
    icon: "ri-user-follow-line",
    iconColor: "success",
  },
  {
    title: "professores",
    value: total_professores,
    desc: "professores cadastrados",
    icon: "ri-user-search-line",
    iconColor: "warning",
  },
  {
    title: "Funcionarios",
    value: total_funcionarios,
    desc: "funcionarios cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
]);

const roles = ["Estudante", "Professor", "Encarregado"];

const headers = [
  { title: "Nome Completo", key: "nome", sortable: true },
  { title: "Username", key: "username", sortable: true },
  { title: "Email", key: "email", sortable: true },
  { title: "Tipo de Utilizador", key: "role", sortable: true },
  { title: "Ações", key: "actions", sortable: false },
];

const paginatedAlunos = computed(() => {
  const start = (page.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return filteredAlunos.value.slice(start, end);
});

const fetchUtilizadores = async () => {
  try {
    const res = await $api("/utilizadores", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    alunos.value = res.map((utilizador) => ({
      id: utilizador.id,
      nome: utilizador.nome,
      username: utilizador.username,
      role: utilizador.role,
      email: utilizador.email,
    }));

    filterUtilizadores();
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};

const filterUtilizadores = () => {
  filteredAlunos.value = alunos.value.filter((utilizador) => {
    const matchesSearch =
      utilizador.nome.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      utilizador.username
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      utilizador.email.toLowerCase().includes(searchQuery.value.toLowerCase());

    const matchesTipoUtilizador =
      !selectedTipoUtilizador.value ||
      utilizador.role === selectedTipoUtilizador.value;

    return matchesSearch && matchesTipoUtilizador;
  });
};

const totalUtilizadores = async () => {
  try {
    const res = await $api("/utilizadores/totais", {
      method: "GET",
    });

    total_utilizadores.value = res;
  } catch (err) {
    console.error("Erro ao buscar utilizadores:", err);
  }
};

const totalAlunos = async () => {
  try {
    const res = await $api("/alunos/totais", {
      method: "GET",
    });

    total_alunos.value = res;
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};

const totalprofessores = async () => {
  try {
    const res = await $api("/professores/totais", {
      method: "GET",
    });

    total_professores.value = res;
  } catch (err) {
    console.error("Erro ao buscar professores:", err);
  }
};

const cadastrarUtilizador = async (userData) => {
  await $api("/autenticacao/cadastro", {
    method: "POST",
    body: userData,
  });

  fetchUtilizadores();
};

const updateOptions = (options) => {
  page.value = options.page;
  sortBy.value = options.sortBy[0]?.key;
  orderBy.value = options.sortBy[0]?.order;
};

watch([searchQuery], filterUtilizadores);

const atualizarDados = () => {
  fetchUtilizadores();
  totalUtilizadores();
  totalprofessores();
  totalAlunos();
};

atualizarDados();

const getIconBtnProps = (item) => {
  if (item.role === "Estudante") {
    return {
      to: {
        name: "utilizadores-alunos-detalhes-id",
        params: { id: item.id },
      },
    };
  } else if (item.role === "Admin") {
    return {
      to: {
        name: "utilizadores-detalhes-id",
        params: { id: item.id },
      },
    };
  } else if (item.role === "Professor") {
    return {
      to: {
        name: "utilizadores-professores-detalhes-id",
        params: { id: item.id },
      },
    };
  } else if (item.role === "Encarregado") {
    return {
      to: {
        name: "utilizadores-encarregados-detalhes-id",
        params: { id: item.id },
      },
    };
  } else {
    return {};
  }
};
</script>

<template>
  <section>
    <div class="d-flex mb-6">
      <VRow>
        <template v-for="data in mini_estatisticas" :key="data.title">
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
        <VCardTitle>Filtrar Utilizadores</VCardTitle>
      </VCardItem>
      <VCardText>
        <VRow>
          <VCol cols="12" sm="4">
            <VAutocomplete
              v-model="selectedTipoUtilizador"
              label="Selecionar o tipo de Utilizador"
              placeholder="Selecionar tipo de Utilizador"
              :items="roles"
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
        >
          Recarregar Dados
        </VBtn>
        <VSpacer />
        <div class="d-flex align-center gap-4 flex-wrap">
          <div class="app-user-search-filter">
            <VTextField
              v-model="searchQuery"
              placeholder="Buscar utilizador"
              density="compact"
            />
          </div>

          <VBtn @click="isCadastrarUtilizadorVisible = true"
            >Cadastrar Utilizador</VBtn
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
          <IconBtn size="small" v-bind="getIconBtnProps(item)">
            <VIcon icon="ri-eye-line" />
          </IconBtn>

          <VBtn
            icon="ri-edit-2-line"
            :icon-color="success"
            variant="plain"
            @click="isEditarAlunoVisible = true"
          />
        </template>
      </VDataTableServer>
    </VCard>

    <CadastrarUtilizador
      v-model:isDrawerOpen="isCadastrarUtilizadorVisible"
      @user-data="cadastrarUtilizador"
    />

    <EditarEstudante
      v-model:isDrawerOpen="isEditarAlunoVisible"
      @user-data="cadastrarUtilizador"
    />
  </section>
</template>

<style lang="scss" scoped>
.app-user-search-filter {
  inline-size: 15.625rem;
}
</style>
