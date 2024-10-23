export default [
  {
    title: "Pagina Inicial",
    to: { name: "root" },
    icon: { icon: "ri-home-smile-2-fill" },
  },

  {
    title: "Utilizadores",
    icon: { icon: "ri-account-circle-line" },
    children: [
      {
        title: "Todos Usuarios",
        to: { name: "utilizadores" },
        icon: { icon: "ri-account-circle-fill" },
      },
      {
        title: "Alunos",
        to: { name: "utilizadores-alunos" },
        icon: { icon: "ri-account-circle-fill" },
      },
      {
        title: "professores",
        to: { name: "utilizadores-professores" },
        icon: { icon: "ri-account-circle-line" },
      },

      {
        title: "Encarregados",
        to: { name: "utilizadores-encarregados" },
        icon: { icon: "ri-account-circle-line" },
      },

      {
        title: "Funcionarios",
        to: { name: "utilizadores-funcionarios" },
        icon: { icon: "ri-account-circle-line" },
      },
    ],
  },
];
