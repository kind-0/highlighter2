import type { DeviceInfo } from "@capacitor/device";
import { writable } from "svelte/store";

export const app_device = writable<DeviceInfo | undefined>(undefined)