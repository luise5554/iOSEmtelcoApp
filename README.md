# iOSEmtelcoApp
# 🐱‍👤 EmtelcoApp - Listado Pokemon con Carrito de Compras  

Una aplicación iOS desarrollada con **SwiftUI** que consume API para listar Pokémons, permite agregarlos a un carrito de compras con autenticación biométrica y funciona incluso con conexión intermitente gracias al almacenamiento en caché y notificaciones locales.

---

## 🚀 Cómo correr el proyecto

1. **Clona el repositorio**  

2.	Abre el proyecto en Xcode  
	•	Requiere Xcode 14+  
	•	Compatible con iOS 16+  
3.	Instala las dependencias  
Este proyecto usa Swift Package Manager (SPM). Xcode descargará automáticamente:  
	•	Alamofire → para consumo de API  
	•	Kingfisher → para carga y caché de imágenes  
	•	RealmSwift → para almacenamiento local offline  
	•	Factory → para inyección de dependencias  
4.	Conecta tu dispositivo físico o selecciona un simulador  
Nota: Para probar biometría se recomienda dispositivo físico con Face ID o Touch ID.  
5.	Ejecuta la app  
	•	Pulsa Run (⌘+R)  

⸻  

🏗️ Arquitectura  

La aplicación está construida usando una combinación de MVVM, Patrón Repositorio e Inyección de dependencias.  
	•	MVVM (Model-View-ViewModel)  
	•	Model: Estructuras que representan los datos de Pokémon y el carrito  
	•	ViewModel: Contiene la lógica de negocio y se comunica con el repositorio  
	•	View: SwiftUI para la UI declarativa, escucha cambios de estado con @StateObject / @Published  
	•	Patrón Repositorio  
	•	Aísla la lógica de acceso a datos (API REST + caché local con Realm)  
	•	Permite intercambiar fácilmente la fuente de datos (API real, mock o cacheada)  
	•	Inyección de dependencias con Factory  
	•	Permite cambiar implementaciones en tiempo de ejecución (por ejemplo usar MockPokemonService para pruebas)  
	•	Facilita el testeo y evita acoplamiento rígido  

⸻

✅ Justificación de funcionalidades clave  
	•	Notificaciones locales para cambio de red
La app detecta cuando el dispositivo pierde o recupera conexión con NWPathMonitor. Esto es importante porque el usuario sabe si puede seguir cargando más Pokémon paginados o si debe esperar hasta restablecerse la conexión.
Además, si la app está en segundo plano, las notificaciones locales mantienen informado al usuario.  
	•	Autenticación biométrica para acceder al carrito
Antes de ver o confirmar el carrito, se valida Face ID / Touch ID. Esto asegura que otro usuario no pueda realizar compras en nombre del dueño del dispositivo, protegiendo así datos y posibles transacciones.  

⸻

🎨 Diseño visual y experiencia de usuario  
	•	Lista paginada de Pokémon
La pantalla principal carga los Pokémon por páginas (offset + limit) para evitar llamadas excesivas y mejorar el rendimiento.  
	•	Imágenes con cache automático
Usando Kingfisher, las imágenes se cachean para poder mostrarse incluso sin conexión.  
	•	Contador dinámico del carrito
En la barra superior, un icono de carrito muestra un badge con la cantidad de Pokémon añadidos en tiempo real.  
	•	Pantalla de carrito optimizada  
	•	Botón para vaciar carrito en la parte superior  
	•	Total en COP calculado dinámicamente en la parte inferior  
	•	Modo offline
Gracias a Realm, la lista se guarda localmente para seguir visualizándola incluso sin conexión.  

⸻

📡 Tecnologías utilizadas  
	•	SwiftUI → interfaz declarativa  
	•	Alamofire → consumo de la API REST  
	•	Kingfisher → carga y cacheo de imágenes  
	•	RealmSwift → almacenamiento local  
	•	Factory → inyección de dependencias  
	•	NWPathMonitor → detección de estado de red  
	•	LocalAuthentication → Face ID / Touch ID para proteger el carrito  
	•	UserNotifications → notificaciones locales por cambios de red  

⸻

🔒 Seguridad  
	•	Autenticación biométrica para proteger acciones sensibles como ver el carrito o realizar compras.  
	•	Separación de lógica de negocio (MVVM + repositorios) para evitar fugas de datos y facilitar testing.  

⸻

📱 Requerimientos  
	•	iOS 16.0 o superior  
	•	Xcode 14 o superior  

⸻

✨ Próximas mejoras  
	•	Integración con API de compras reales  
	•	Sincronización del carrito en la nube  
	•	Soporte para temas claros/oscuro personalizados  

⸻

📸 Screenshots (*)  

<img src="https://github.com/user-attachments/assets/94878bdf-8c81-47ed-a88c-998c0f753314" width="200"/>
<img src="https://github.com/user-attachments/assets/0733e9b4-c007-4de4-aa6f-e23d3384d19d" width="200"/>
<img src="https://github.com/user-attachments/assets/d760231b-227f-40fe-b700-ce01bcbdcdc2" width="200"/>
<img src="https://github.com/user-attachments/assets/7026d20d-d5d2-4348-826d-6600cb9f96eb" width="200"/>
<img src="https://github.com/user-attachments/assets/b36c50e9-81c7-45df-8b0b-dae09889494c" width="200"/>

⸻

➡️ [**Descargar .ipa**]
No se deja opción de descarga de .ipa ya que fuera funcional requeriría una cuenta de desarrollador Apple con permiso para distribución in House (Cuenta Entre Price). Se hace la observacion de que hay otras maneras de distribución como TestFlight con link publico, App Store, Ad Hoc, entre otras, pero por el momento se salen del alcance de este proyecto.
Por el momento para que puedas usar esta aplicación debes instalarla desde Xcode.
____

👨‍💻 Autor

Luis Suárez
📧 luise5554@gmail.com  
🌐 https://www.linkedin.com/in/luis-eduardo-su%C3%A1rez-pati%C3%B1o-70bb83a8/

⸻

Esta app demuestra buenas prácticas en arquitectura iOS moderna, persistencia offline, seguridad con biometría y una UX adaptada a contextos de red variables.
