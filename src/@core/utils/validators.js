import { isEmpty, isEmptyArray, isNullOrUndefined } from "./helpers";

// 👉 Required Validator
export const requiredValidator = (value) => {
  if (isNullOrUndefined(value) || isEmptyArray(value) || value === false)
    return "Este campo é obrigatório";

  return !!String(value).trim().length || "Este campo é obrigatório";
};

// 👉 Email Validator
export const emailValidator = (value) => {
  if (isEmpty(value)) return true;
  const re =
    /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  if (Array.isArray(value))
    return (
      value.every((val) => re.test(String(val))) ||
      "O campo Email deve ser um email válido"
    );

  return re.test(String(value)) || "O campo Email deve ser um email válido";
};

// 👉 Password Validator
export const passwordValidator = (password) => {
  const regExp = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%&*()]).{8,}/;
  const validPassword = regExp.test(password);

  return (
    validPassword ||
    "O campo deve conter pelo menos um caractere especial maiúsculo, minúsculo e um dígito com no mínimo 8 caracteres"
  );
};

// 👉 Confirm Password Validator
export const confirmedValidator = (value, target) =>
  value === target || "A confirmação do campo Confirmar Senha não corresponde";

// 👉 Between Validator
export const betweenValidator = (value, min, max) => {
  const valueAsNumber = Number(value);

  return (
    (Number(min) <= valueAsNumber && Number(max) >= valueAsNumber) ||
    `Insira um número entre ${min} e ${max}`
  );
};

// 👉 Integer Validator
export const integerValidator = (value) => {
  if (isEmpty(value)) return true;
  if (Array.isArray(value))
    return (
      value.every((val) => /^-?[0-9]+$/.test(String(val))) ||
      "Este campo deve ser um número inteiro"
    );

  return (
    /^-?[0-9]+$/.test(String(value)) || "Este campo deve ser um número inteiro"
  );
};

// 👉 Regex Validator
export const regexValidator = (value, regex) => {
  if (isEmpty(value)) return true;
  let regeX = regex;
  if (typeof regeX === "string") regeX = new RegExp(regeX);
  if (Array.isArray(value))
    return value.every((val) => regexValidator(val, regeX));

  return regeX.test(String(value)) || "O formato do campo Regex é inválido";
};

// 👉 Alpha Validator
export const alphaValidator = (value) => {
  if (isEmpty(value)) return true;

  return (
    /^[A-Z]*$/i.test(String(value)) ||
"O campo Alfa só pode conter caracteres alfabéticos"  );
};

// 👉 URL Validator
export const urlValidator = (value) => {
  if (isEmpty(value)) return true;
  const re = /^(https?):\/\/[^\s$.?#].[^\s]*$/;

  return re.test(String(value)) || "O URL é inválido";
};

// 👉 Length Validator
export const lengthValidator = (value, length) => {
  if (isEmpty(value)) return true;

  return (
    String(value).length === length ||
`O campo deve ter pelo menos ${length} caracteres`
  );
};

// 👉 Alpha-dash Validator
export const alphaDashValidator = (value) => {
  if (isEmpty(value)) return true;
  const valueAsString = String(value);

  return /^[0-9A-Z_-]*$/i.test(valueAsString) || "Todos os caracteres não são válidos";
};

