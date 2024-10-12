<script setup>
import Sobre from "@/views/utilizadores/detalhes/Sobre.vue";
import { onMounted, ref } from "vue";

const route = useRoute("utilizadores-detalhes-id"); // Assumindo que o nome da rota é "utilizadores-estudantes-detalhes-id"
const userTab = ref(null);
const userData = ref(null); // Para armazenar os dados do aluno

const token = useCookie("accessToken").value;

const tabs = [
  {
    icon: "ri-group-line",
    title: "Encarregados",
    content:
      "Informações sobre os pais ou responsáveis, contacto de emergência e dados relacionados.",
  },

  {
    icon: "ri-book-line",
    title: "Histórico Académico",
    content:
      "Histórico escolar, disciplinas, notas, e situação académica atual.",
  },
];

// Função para buscar os dados do aluno
const fetchAluno = async () => {
  try {
    const res = await $api(`/utilizadores/utilizador/${route.params.id}`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    // Verifique se o resultado existe antes de preencher os dados

    if (res) {
      userData.value = {
        id: res.id,
        nomeCompleto: res.nome,
        username: res.username,
        email: res.email,
      };
    } else {
      console.error("Nenhum dado de aluno encontrado.");
    }
  } catch (err) {
    console.error("Erro ao buscar aluno:", err);
  }
};

// Carregar os dados do aluno assim que o componente for montado
onMounted(() => {
  fetchAluno();
});
</script>
<template>
  <VRow v-if="userData">
    <!-- Painel de informações do aluno -->
    <VCol cols="12" md="5" lg="4">
      <Sobre :user-data="userData" />
    </VCol>

    <!-- Tabs com informações adicionais -->
    <VCol cols="12" md="7" lg="8">
      <VTabs v-model="userTab" class="v-tabs-pill">
        <VTab v-for="tab in tabs" :key="tab.icon">
          <VIcon start :icon="tab.icon" />
          <span>{{ tab.title }}</span>
        </VTab>
      </VTabs>

      <!-- Conteúdo das abas -->
      <VWindow
        v-model="userTab"
        class="mt-6 disable-tab-transition"
        :touch="false"
      >
      </VWindow>
    </VCol>
  </VRow>

  <!-- Alerta se o aluno não for encontrado -->
  <div v-else>
    <VAlert type="error" variant="tonal">
      Utilizador {{ route.params.id }} não encontrado!
    </VAlert>
  </div>
</template>
