#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# VM에서 실행하세요. 실제 클러스터 상태/매니페스트를 파일로 덤프합니다.
# 사용법:  bash dump-cluster.sh   →  ./nimbus-dump/ 폴더 생성
# 이 폴더 내용을 이 레포의 해당 위치로 옮기면 됩니다.
# (읽기 전용 명령만 사용 — 클러스터를 변경하지 않습니다)
# ─────────────────────────────────────────────────────────────
set -e
OUT="./nimbus-dump"
mkdir -p "$OUT"/{state,manifests,monitoring,cluster}

echo "[1/5] 클러스터 상태 스냅샷"
kubectl get nodes -o wide            > "$OUT/state/nodes.txt"
kubectl get pods -A -o wide          > "$OUT/state/pods.txt"
kubectl get ns                       > "$OUT/state/namespaces.txt"
kubectl get ingress -A               > "$OUT/state/ingress.txt"
kubectl get svc -A                   > "$OUT/state/services.txt"
kubectl version                      > "$OUT/state/versions.txt" 2>/dev/null || true

echo "[2/5] 실제 적용된 매니페스트 덤프"
# grafana ingress (직접 만든 것)
kubectl get ingress grafana -n monitoring -o yaml 2>/dev/null > "$OUT/manifests/grafana-ingress.yaml" || true
# ingress-nginx / console 등 핵심 리소스
kubectl get ingress -A -o yaml       > "$OUT/manifests/all-ingress.yaml"

echo "[3/5] 모니터링 스택 helm values (설치돼 있으면)"
helm get values prometheus -n monitoring > "$OUT/monitoring/prometheus-values.yaml" 2>/dev/null \
  || helm list -A > "$OUT/monitoring/helm-releases.txt" 2>/dev/null || true

echo "[4/5] 클러스터 구성 힌트 (kubeadm/CNI/런타임)"
{ echo "# containerd"; sudo systemctl status containerd --no-pager 2>/dev/null | head -3; } > "$OUT/cluster/runtime.txt" || true
kubectl get pods -n kube-system      > "$OUT/cluster/kube-system-pods.txt"   # calico/flannel 확인용

echo "[5/5] socat / backend systemd 유닛 (있으면)"
{ systemctl cat socat* 2>/dev/null; systemctl cat nimbus* backend* 2>/dev/null; } > "$OUT/cluster/systemd-units.txt" || true

echo "완료 → $OUT/  (이 폴더를 레포로 옮기세요)"
